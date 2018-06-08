#include "uart_regs.h"

#define GPIO_REG  	0x00101880
#define CPSR_REG	0x00101890
#define CSD_MEM 	0x001018A0

.macro debugging_macro
	ldr r12, =GPIO_REG
	mov r1, #16
	ldr r2, =CSD_MEM
	sub r12, r12, #48

reg_read:
	ldr r0, [r12], #4

	ldr r3, =0x72						// insert 'r'
	strb r3, [r2], #1

	cmp r1, #16							// if r0 insert '0'
	ldreq r3, =0x30
	streqb r3, [r2], #1

	cmp r1, #15							// if r1 insert '1'
	ldreq r3, =0x31
	streqb r3, [r2], #1

	cmp r1, #14							// if r2 insert '2'
	ldreq r3, =0x32
	streqb r3, [r2], #1

	cmp r1, #13							// if r3 insert '3'
	ldreq r3, =0x33
	streqb r3, [r2], #1

	cmp r1, #12							// if r4 insert '4'
	ldreq r3, =0x34
	streqb r3, [r2], #1

	cmp r1, #11							// if r5 insert '5'
	ldreq r3, =0x35
	streqb r3, [r2], #1

	cmp r1, #10							// if r6 insert '6'
	ldreq r3, =0x36
	streqb r3, [r2], #1

	cmp r1, #9							// if r7 insert '7'
	ldreq r3, =0x37
	streqb r3, [r2], #1

	cmp r1, #8							// if r8 insert '8'
	ldreq r3, =0x38
	streqb r3, [r2], #1

	cmp r1, #7							// if r9 insert '9'
	ldreq r3, =0x39
	streqb r3, [r2], #1

	cmp r1, #6							// if r10 insert '10'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x30
	streqb r3, [r2], #1

	cmp r1, #5							// if r11 insert '11'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x31
	streqb r3, [r2], #1

	cmp r1, #4							// if r12 insert '12'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x32
	streqb r3, [r2], #1

	cmp r1, #3							// if r13 insert '13'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x33
	streqb r3, [r2], #1

	cmp r1, #2							// if r14 insert '14'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x34
	streqb r3, [r2], #1

	cmp r1, #1							// if r15 insert '15'
	ldreq r3, =0x31
	streqb r3, [r2], #1
	ldreq r3, =0x35
	streqb r3, [r2], #1



	// " = 0x"

	ldr r3, =0x20						// insert space
	strb r3, [r2], #1

	ldr r3, =0x3D						// insert '='
	strb r3, [r2], #1

	ldr r3, =0x20
	strb r3, [r2], #1					// insert space

	ldr r3, =0x30						// insert '0'
	strb r3, [r2], #1

	ldr r3, =0x78						// insert 'x'
	strb r3, [r2], #1


	// 한자리씩 추출

	ldr r3, =0x0FFFFFFF					// insert first hex value
	bic r3, r0, r3						// bic : and not
	mov r3, r3, LSR #28
	bl print_gpio_num

	ldr r3, =0xF0FFFFFF					// insert second hex value
	bic r3, r0, r3
	mov r3, r3, LSR #24
	bl print_gpio_num

	ldr r3, =0xFF0FFFFF					// insert third hex value
	bic r3, r0, r3
	mov r3, r3, LSR #20
	bl print_gpio_num

	ldr r3, =0xFFF0FFFF					// insert forth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #16
	bl print_gpio_num

	ldr r3, =0x5F						// insert '_'
	strb r3, [r2], #1

	ldr r3, =0xFFFF0FFF					// insert fifth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #12
	bl print_gpio_num

	ldr r3, =0xFFFFF0FF					// insert sixth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #8
	bl print_gpio_num

	ldr r3, =0xFFFFFF0F					// insert seventh hex value
	bic r3, r0, r3
	mov r3, r3, LSR #4
	bl print_gpio_num

	ldr r3, =0xFFFFFFF0					// insert last hex value
	bic r3, r0, r3
	bl print_gpio_num				// 출력 완료



	// ", "

	ldr r3, =0x2C						// insert ','
	strb r3, [r2], #1

	ldr r3, =0x20						// insert space
	strb r3, [r2], #1


	// new line 파악 후 줄 띄우기

	cmp r1, #13							// if r3 is inserted, insert line feed, carrige return
	ldreq r3, =0x0A
	streqb r3, [r2], #1
	ldreq r3, =0x0D
	streqb r3, [r2], #1

	cmp r1, #9							// if r7 is inserted, insert line feed, carrige return
	ldreq r3, =0x0A
	streqb r3, [r2], #1
	ldreq r3, =0x0D
	streqb r3, [r2], #1

	cmp r1, #5							// if r11 is inserted, insert line feed, carrige return
	ldreq r3, =0x0A
	streqb r3, [r2], #1
	ldreq r3, =0x0D
	streqb r3, [r2], #1

	cmp r1, #1							// if r15 is inserted, insert line feed, carrige return
	ldreq r3, =0x0A
	streqb r3, [r2], #1


	ldreq r3, =0x0D	// carriage return
	streqb r3, [r2], #1

	subs r1, r1, #1
	bne reg_read	// 다음 레지스터 읽으러 ㄱㄱ


	// GPIO 레지스터를 모두 출력했다면 CPSR을 출력해보자
	// "cpsr = " 출력

	ldr r3, =0x63						// 'c'
	strb r3, [r2], #1

	ldr r3, =0x70						// 'p'
	strb r3, [r2], #1

	ldr r3, =0x73						// 's'
	strb r3, [r2], #1

	ldr r3, =0x72						// 'r'
	strb r3, [r2], #1

	ldr r3, =0x20						// space
	strb r3, [r2], #1

	ldr r3, =0x3D						// '='
	strb r3, [r2], #1

	ldr r3, =0x20						// space
	strb r3, [r2], #1



	// NZCV값 출력하기

	ldr r11, =CPSR_REG
	ldr r0, [r11]
	ldr r3, =0x0FFFFFFF
	bic r3, r0, r3
	mov r3, r3, LSR #28 				// 맨 앞 비트의 정체를 파악하기

	mov r4, r3, LSR #3					// get N bit
	cmp r4, #1							// N bit가 1이라면
	ldreq r5, =0x4E						// 출력
	streqb r5, [r2], #1 				// 출력

	cmp r4, #0
	ldreq r5, =0x6E						// if N bit is 0, print 'n'
	streqb r5, [r2], #1

	mov r4, r3, LSR #2					// get Z bit
	and r4, r4, #1
	cmp r4, #1
	ldreq r5, =0x5A						// if Z bit is 1, print 'Z'
	streqb r5, [r2], #1

	cmp r4, #0
	ldreq r5, =0x7A						// if Z bit is 0, print 'z'
	streqb r5, [r2], #1

	mov r4, r3, LSR #1					// get C bit
	and r4, r4, #1
	cmp r4, #1
	ldreq r5, =0x43						// if C bit is 1, print 'C'
	streqb r5, [r2], #1

	cmp r4, #0
	ldreq r5, =0x63						// if C bit is 0, print 'c'
	streqb r5, [r2], #1

	mov r4, r3
	and r4, r4, #1						// get V bit
	cmp r4, #1
	ldreq r5, =0x56						// if V bit is 1, print 'V'
	streqb r5, [r2], #1

	cmp r4, #0
	ldreq r5, =0x76						// if V bit is 0, print 'v'
	streqb r5, [r2], #1



	// ", " 출력

	ldr r5, =0x2C						// ','
	str r5, [r2], #1

	ldr r5, =0x20						// space
	str r5, [r2], #1



	// IF값 출력

	mov r3, r0, LSR #6
	ldr r4, =0xFFFFFFFC
	bic r3, r3, r4						// get IF bits

	cmp r3, #0							// if IF is 00 print 'if'
	ldreq r5, =0x69
	streqb r5, [r2], #1
	ldreq r5, =0x66
	streqb r5, [r2], #1

	cmp r3, #1							// if IF is 01 print 'iF'
	ldreq r5, =0x69
	streqb r5, [r2], #1
	ldreq r5, =0x46
	streqb r5, [r2], #1

	cmp r3, #2							// if IF is 10 print 'If'
	ldreq r5, =0x49
	streqb r5, [r2], #1
	ldreq r5, =0x66
	streqb r5, [r2], #1

	cmp r3, #3							// if IF is 11 print 'IF'
	ldreq r5, =0x49
	streqb r5, [r2], #1
	ldreq r5, =0x46
	streqb r5, [r2], #1



	// ", " 출력

	ldr r5, =0x2C						// ','
	strb r5, [r2], #1

	ldr r5, =0x20						// space
	strb r5, [r2], #1



	// JT값 출력

	ldr r3, =0xFEFFFFDF					// get J,T bits
	bic r3, r0, r3

	cmp r3, #0							// if JF is 0..0 print 'ARM'
	ldreq r5, =0x41
	streq r5, [r2], #1

	ldreq r5, =0x52
	streq r5, [r2], #1

	ldreq r5, =0x4D
	streq r5, [r2], #1

	ldr r4, =0x00000020					// if JF is 0..1 print 'Thumb'
	cmp r3, r4
	ldreq r5, =0x54
	streqb r5, [r2], #1

	ldreq r5, =0x68
	streqb r5, [r2], #1

	ldreq r5, =0x75
	streqb r5, [r2], #1

	ldreq r5, =0x6D
	streqb r5, [r2], #1

	ldreq r5, =0x62
	streqb r5, [r2], #1

	ldr r4, =0x01000000					// if JF is 1..0 print 'Jazelle'
	cmp r3, r4
	ldreq r5, =0x4A
	streqb r5, [r2], #1

	ldreq r5, =0x61
	streqb r5, [r2], #1

	ldreq r5, =0x7A
	streqb r5, [r2], #1

	ldreq r5, =0x65
	streqb r5, [r2], #1

	ldreq r5, =0x6C
	streqb r5, [r2], #1

	ldreq r5, =0x6C
	streqb r5, [r2], #1

	ldreq r5, =0x65
	streqb r5, [r2], #1

	ldr r4, =0x01000020					// if JF is 1..1 print 'ThumbEE'
	cmp r3, r4

	ldreq r5, =0x54
	streqb r5, [r2], #1

	ldreq r5, =0x68
	streqb r5, [r2], #1

	ldreq r5, =0x75
	streqb r5, [r2], #1

	ldreq r5, =0x6D
	streqb r5, [r2], #1

	ldreq r5, =0x62
	streqb r5, [r2], #1

	ldreq r5, =0x45
	streqb r5, [r2], #1

	ldreq r5, =0x45
	streqb r5, [r2], #1



	// "mode, current mode = " 출력

	ldr r5, =0x20						// space
	strb r5, [r2], #1

	ldr r5, =0x6D						// 'm'
	strb r5, [r2], #1

	ldr r5, =0x6F						// 'o'
	strb r5, [r2], #1

	ldr r5, =0x64						// 'd'
	strb r5, [r2], #1

	ldr r5, =0x65						// 'e'
	strb r5, [r2], #1

	ldr r5, =0x2C						// ','
	strb r5, [r2], #1

	ldr r5, =0x20						// space
	strb r5, [r2], #1

	ldr r5, =0x63						// 'c'
	strb r5, [r2], #1

	ldr r5, =0x75						// 'u'
	strb r5, [r2], #1

	ldr r5, =0x72						// 'r'
	strb r5, [r2], #1

	ldr r5, =0x72						// 'r'
	strb r5, [r2], #1

	ldr r5, =0x65						// 'e'
	strb r5, [r2], #1

	ldr r5, =0x6E						// 'n'
	strb r5, [r2], #1

	ldr r5, =0x74						// 't'
	strb r5, [r2], #1

	ldr r5, =0x20
	strb r5, [r2], #1					// space

	ldr r5, =0x6D						// 'm'
	strb r5, [r2], #1

	ldr r5, =0x6F						// 'o'
	strb r5, [r2], #1

	ldr r5, =0x64						// 'd'
	strb r5, [r2], #1

	ldr r5, =0x65						// 'e'
	strb r5, [r2], #1

	ldr r5, =0x20						// space
	strb r5, [r2], #1

	ldr r5, =0x3D						// '='
	strb r5, [r2], #1

	ldr r5, =0x20						// space
	strb r5, [r2], #1



	// MODE값 받아와서 출력

	ldr r3, =0xFFFFFFE0					// get mode[4:0] bits
	bic r3, r0, r3

	cmp r3, #16							// if mode bits are 10000, print 'USR'
	ldreq r5, =0x55
	streqb r5, [r2], #1

	ldreq r5, =0x53
	streqb r5, [r2], #1

	ldreq r5, =0x52
	streqb r5, [r2], #1


	cmp r3, #17							// if mode bits are 10001, print 'FIQ'
	ldreq r5, =0x46
	streqb r5, [r2], #1

	ldreq r5, =0x49
	streqb r5, [r2], #1

	ldreq r5, =0x51
	streqb r5, [r2], #1


	cmp r3, #18							// if mode bits are 10010, print 'IRQ'
	ldreq r5, =0x49
	streqb r5, [r2], #1

	ldreq r5, =0x52
	streqb r5, [r2], #1

	ldreq r5, =0x51
	streqb r5, [r2], #1


	cmp r3, #19							// if mode bits are 10011, print 'SVC'
	ldreq r5, =0x53
	streqb r5, [r2], #1

	ldreq r5, =0x56
	streqb r5, [r2], #1

	ldreq r5, =0x43
	streqb r5, [r2], #1


	cmp r3, #22							// if mode bits are 10110, print 'MON'
	ldreq r5, =0x4D
	streqb r5, [r2], #1

	ldreq r5, =0x4F
	streqb r5, [r2], #1

	ldreq r5, =0x4E
	streqb r5, [r2], #1


	cmp r3, #23							// if mode bits are 10111, print 'ABT'
	ldreq r5, =0x41
	streqb r5, [r2], #1

	ldreq r5, =0x42
	streqb r5, [r2], #1

	ldreq r5, =0x54
	streqb r5, [r2], #1


	cmp r3, #26							// if mode bits are 11010, print 'HYP'
	ldreq r5, =0x48
	streqb r5, [r2], #1

	ldreq r5, =0x59
	streqb r5, [r2], #1

	ldreq r5, =0x50
	streqb r5, [r2], #1


	cmp r3, #27							// if mode bits are 11011, print 'UND'
	ldreq r5, =0x55
	streqb r5, [r2], #1

	ldreq r5, =0x4E
	streqb r5, [r2], #1

	ldreq r5, =0x44
	streqb r5, [r2], #1


	cmp r3, #31							// if mode bits are 11111, print 'SYS'
	ldreq r5, =0x53
	streqb r5, [r2], #1

	ldreq r5, =0x59
	streqb r5, [r2], #1

	ldreq r5, =0x53
	streqb r5, [r2], #1


	//
	ldr r5, =0x20						// space
	strb r5, [r2], #1

	ldr r5, =0x28						// '('
	strb r5, [r2], #1

	ldr r5, =0x3D						// '='
	strb r5, [r2], #1

	ldr r3, =0x30						// insert '0'
	strb r3, [r2], #1

	ldr r3, =0x78						// insert 'x'
	strb r3, [r2], #1

	ldr r3, =0x0FFFFFFF					// insert first hex value
	bic r3, r0, r3
	mov r3, r3, LSR #28
	bl print_gpio_num

	ldr r3, =0xF0FFFFFF					// insert second hex value
	bic r3, r0, r3
	mov r3, r3, LSR #24
	bl print_gpio_num

	ldr r3, =0xFF0FFFFF					// insert third hex value
	bic r3, r0, r3
	mov r3, r3, LSR #20
	bl print_gpio_num

	ldr r3, =0xFFF0FFFF					// insert forth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #16
	bl print_gpio_num

	ldr r3, =0x5F						// insert '_'
	strb r3, [r2], #1

	ldr r3, =0xFFFF0FFF					// insert fifth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #12
	bl print_gpio_num

	ldr r3, =0xFFFFF0FF					// insert sixth hex value
	bic r3, r0, r3
	mov r3, r3, LSR #8
	bl print_gpio_num

	ldr r3, =0xFFFFFF0F					// insert seventh hex value
	bic r3, r0, r3
	mov r3, r3, LSR #4
	bl print_gpio_num

	ldr r3, =0xFFFFFFF0					// insert last hex value
	bic r3, r0, r3
	bl print_gpio_num

	ldr r5, =0x29						// ')'
	strb r5, [r2], #1

	ldr r5, =0x0A						// line feed
	strb r5, [r2], #1

	ldr r3, =0x0A
	strb r3, [r2], #1

	ldr r5, =0x0D						// carrige return
	strb r5, [r2], #1

	ldr r0, =0x00						// end of string
	strb r0, [r2]
	b end_debug



// GPIO 레지스터 "번호" 출력
print_gpio_num:
	cmp r3, #0
	moveq r3, #0x30
	streqb r3, [r2], #1
	moveq pc, lr	// 다음 자리 숫자 출력하러 이동

	cmp r3, #1
	moveq r3, #0x31
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #2
	moveq r3, #0x32
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #3
	moveq r3, #0x33
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #4
	moveq r3, #0x34
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #5
	moveq r3, #0x35
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #6
	moveq r3, #0x36
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #7
	moveq r3, #0x37
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #8
	moveq r3, #0x38
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #9
	moveq r3, #0x39
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #10
	moveq r3, #0x41
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #11
	moveq r3, #0x42
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #12
	moveq r3, #0x43
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #13
	moveq r3, #0x44
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #14
	moveq r3, #0x45
	streqb r3, [r2], #1
	moveq pc, lr

	cmp r3, #15
	moveq r3, #0x46
	streqb r3, [r2], #1
	moveq pc, lr

end_debug:
.endm
