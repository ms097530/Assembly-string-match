.386
.MODEL FLAT, stdcall
.STACK 4096
ExitProcess PROTO,
dwExitCode:DWORD

.data
src BYTE "Try larder", 0
len1 EQU ($ - src)
dst BYTE "Try harder", 0			; tests if different same length strings cause a match
; dst BYTE "Try harder still", 0	; tests if different length strings cause a match
len2 EQU ($ - src)
index BYTE ?

.code
_main PROC

; zero out registers that will be used
xor esi, esi
xor edi, edi
xor eax, eax
xor ecx, ecx
; load source and destination string addresses into registers
lea esi, src
lea edi, dst

; check string lengths - move into ecx so if len1 is shorter or equal don't have to change anything
mov ecx, len1
cmp ecx, len2
jg twoGreater
mov eax, len1
jmp compare

; move smaller length into ecx
twoGreater:
mov eax, len2
mov ecx, len2

; compare the string/substring for equality
compare:
cld
repz cmpsb

; subtract remaining number in ecx to get number of letters matched -> decrement and move this number 
; into index for index that caused end of loop
sub eax, ecx
dec eax
mov index, al

; if whole substring/string matches, index = number of letters (length of string - 1)
; otherwise, index will be the index number that caused the mismatch
mov ecx, len1
cmp ecx, len2
jg twoGreater2
jmp lengthCmp

twoGreater2:
mov ecx, len2

; compare original lengths to index
lengthCmp:
dec ecx
cmp cl, index
je equal
jne notEqual


equal:
; equality things
xor ebx, ebx
jmp done

notEqual:
; inequality things
xor ebx, ebx
done:
; finish up

INVOKE ExitProcess, 0
_main ENDP
END