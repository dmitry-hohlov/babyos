                .model  tiny
                .186

                public  C InitSyscalls

                extern  C CreateProcess : near
                extern  C SetInterruptHandler : near

                .code

_SYSCALLS_COUNT equ     1
_HANDLER_POINTER_SIZE \
                equ     2
_SYSCALL_INTERRUPT \
                equ     0x90

_pSyscallHandlers \
                dw      _SYSCALLS_COUNT dup( ? )

; void public InitSyscalls();
InitSyscalls:
                push    bx
                push    es
                push    di

                mov     bx, offset _pSyscallHandlers

                mov     [ bx ], offset CreateProcess
                add     bx, _HANDLER_POINTER_SIZE

                push    cs
                push    offset _SyscallMainHandler
                push    word ptr _SYSCALL_INTERRUPT
                call    SetInterruptHandler
                add     sp, 6

                pop     di
                pop     es
                pop     bx
                ret
; конец InitSyscalls

; Обработчик прерывания
_SyscallMainHandler:
                cmp     bx, _SYSCALLS_COUNT
                jae     @exitHandler

                call    near ptr _pSyscallHandlers[ bx ]

@exitHandler:
                iret
; конец _SyscallMainHandler


                end