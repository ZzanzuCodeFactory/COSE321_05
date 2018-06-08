#include "uart_init.s"
#include "debugging_macro.s"
#include "uart_print.s"

#define GPIO_REG  	0x00101880
#define CPSR_REG	0x00101890

.extern csd_main
.align 8

// Our interrupt vector table
cydf_entry:
	b csd_reset
	b .
	b .
	b .
	b .
	b .
	b cydf_irq
	b .

.global main
csd_reset:

main:
	uart_init

	ldr r0, = Input_data // address of Input data memory
    ldr r3, = Output_data // next address of Input data memory
    sub r3, r3, #4 // end address of Input data memory

	mov r5, r0 // copying starting address

loop:
	mov r4, #0 // boolean isSwapped = false;
    mov r5, r0 // initializing starting address

	// GPIO값 저장하기
	stmdb sp!, {r0 - r12} // r0부터 r12까지의 값을 스택에 저장
	ldr r12, =GPIO_REG
	stmdb r12!, {r0 - r11} // r0부터 r11까지의 값을 GPIO_REG스택에 저장
	str r12, [r12]
	sub r12, r12, #4
	stmdb r12!, {r13 - r15}

	// CPSR값 저장하기
	mrs r0, cpsr // move the cpsr value to gpio register
	ldr r1, =CPSR_REG
	str r0, [r1]

	debugging_macro // r0~12값이 뒤죽박죽 바뀜
	uart_print

	ldr r0, =CPSR_REG
	msr cpsr, r0 // move the gpio value to cpsr register
	ldmia sp!, {r0 - r12}
	stmdb sp!, {r0 - r12}
	ldmia sp!, {r0 - r12}

  	inner_loop:

    ldr r1, [r5], #4 // number 1
    ldr r2, [r5] // number 2
    cmp r1, r2 // comparing both numbers

    strge r1, [r5] // if r1 >= r2 changes two numbers' memory location
    strge r2, [r5, #-4] // if r1 >= r2 changes two numbers' memory location

    movge r4, #1 // isSwapped = true;

    cmp r5, r3 // if not reached the final address of Input_data,
    bne inner_loop @ do bubble sorting continously

    cmp r4, #1 // if any one sorting happend,
    beq loop // sort again

forever:
	nop
	b forever

.data
.align 4

Input_data:
	.word 2, 0, -7, -1, 3, 8, -4, 10
	.word -9, -16, 15, 13, 1, 4, -3, 14
    .word -8, -10, -15, 6, -13, -5, 9, 12
    .word -11, -14, -6, 11, 5, 7, -2, -12

Output_data:
	.space 128 @ 4*32, but not used.

cydf_irq:
	b .
