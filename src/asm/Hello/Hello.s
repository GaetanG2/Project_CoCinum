
    .set INTC_EVENTS,         0x81000004
    .set UART_DATA,           0x82000000
    .set INTC_EVENTS_UART_TX, 2

    .global main
main:
    la x5, str
    li x6, INTC_EVENTS
    li x7, UART_DATA

main_loop:
    lb x4, (x5)
    beqz x4, main_end

    sb x4, (x7)

main_polling_loop:
    lw x4, (x6)
    andi x4, x4, INTC_EVENTS_UART_TX
    beqz x4, main_polling_loop
    sw x4, (x6)

    addi x5, x5, 1
    j main_loop

main_end:
    ret

str:
    .asciz "Virgule says\n<< Hello! >>\nfrom assembly.\n"
