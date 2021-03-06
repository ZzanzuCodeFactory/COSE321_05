#include "uart_regs.h"
#define CSD_MEM 0x001018A0
.data

.macro uart_print
uart_trans:

//////////////////////////////////////////////
//       아래에 오류 발생 시 clean project  //
//////////////////////////////////////////////

	ldr 	r0, =UART1_BASE
	ldr 	r1, =CSD_MEM

TRANSMIT_loop:

	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr 	r2, [r0, #UART_CHANNEL_STS_REG0_OFFSET]	@ get Channel Status Register
	and	r2, r2, #0x8		@ get Transmit Buffer Empty bit(bit[3:3])
	cmp	r2, #0x8				@ check if TxFIFO is empty and ready to receive new data
	bne	TRANSMIT_loop		@ if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	ldrb     r3, [r1], #1
	streqb	r3, [r0, #UART_TX_RX_FIFO0_OFFSET]	@ fill the TxFIFO with 0x48
	cmp      r3, #0x00
	bne		TRANSMIT_loop

.endm


