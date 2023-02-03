; vim: ft=masm

; == Instructions ==

; -- Data movement instructions --
mov eax, 2 ; moves constant to eax register
push eax ; pushes register or address value to hardware stack
pop ebx ; remove data from stack and place it in ebx
lea ecx, [var] ; same as mov, but as source takes address and places it's value to destination

; -- Arithmetic and logic instructions --
add eax, 10 ; adds 1st and 2nd operands and stores in 1st operand
sub ebx, 5 ; (1st - 2nd) and places it into 1st operand
inc DWORD PTR [var] ; add one to the 32-bit integer stored at location var
dec ebx ; decrement register
imul eax, [var] ; multiply the contents of EAX by the 32-bit contents of the memory location var. Store the result in EAX.
imul esi, edi, 25 ; ESI → EDI * 25 
idiv ebx ; divide the contents of EDX:EAX by the contents of EBX. Place the quotient in EAX and the remainder in EDX.
idiv DWORD PTR [var] ; divide the contents of EDX:EAX by the 32-bit value stored at memory location var. Place the quotient in EAX and the remainder in EDX.
and eax, 0fH ; clear all but the last 4 bits of EAX.
xor edx, edx ; set the contents of EDX to zero.
not BYTE PTR [var] ; negate all bits in the byte at the memory location var.
neg eax ; EAX → - EAX
shl eax, 1 ; logical left shift, filling the lowest but with 0. This action also multiplies the value of eax by 2 (2^n) (if the most significant bit is 0)
shr ebx, 2 ; logical right shift, highest bit position is filled with a zero. This action also divides the operand by 4 (2^n)
sal eax, 1 ; arithmetic left shift, identical to logical shl
sar ebx, 2 ; arithmetic right shift, that preserves the number's sign

; -- Control flow instructions --
jmp helloworld ; jump to the instruction labeled helloworld
; j[condition] <label> (jump conditionally to label)
je <label> ; jump when equal
jne <label> ; jump when not equal
jz <label> ; jump when last result was zero
jg <label> ; jump when greater than
jge <label> ; jump when greater than or equal to
jl <label> ; jump when less than
jle <label> ; jump when less than or equal to
cmp <op1> <op2> ; compare the values of the two specified operands, setting the condition codes in the machine status word appropriately
call helloworld ; save (push instructions) current location to stack and jump to label helloworld
ret ; pop last location from stack and perform unconditional jump to that location
 

; == Calling conventions ==

; -- Caller rules --
; 1) Save EAX, ECX and EDX to stack if values are expected to be used after calling a subroutine 
; 2) The parameters should be pushed into stack in the inverted order 
; 3) Use `call` instruction to call the subroutine
; After:
; 1) Remove parameters from stack
; 2) Restore the contents of caller-saved registers (EAX, ECX, EDX) by popping them off of the stack

; -- Callee rules --
; 1) Push the value of EBP onto the stack, and then copy the value of ESP into EBP using the following instructions: 
     push ebp
     mov ebp, esp
; 2) Allocation of local variables happens by decrementing the stack pointer by (n*4), as every cell takes 32bit
; 3) Save EBX, EDI and ESI to stack if are used in a future
; After:
; 1) Leave the return value in EAX
; 2) Restore the old values of any callee-saved registers (EDI and ESI) that were modified.
;    The register contents are restored by popping them from the stack.
;    The registers should be popped in the inverse order that they were pushed.
; 3) Deallocate local variables:
     mov esp, ebp
;    We could also subtract from stack pointer, but this is less error-prone way
; 4) Pop EBP off the stack
; 5) Execute `ret`. This instruction will find and remove the appropriate return address from the stack.


; == Examples ==

; If the contents of EAX are less than or equal to the contents of EBX, jump to the label done. Otherwise, continue to the next instruction.
cmp eax, ebx
jle done
