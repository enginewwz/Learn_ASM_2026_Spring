x86-64 case

echo 'mov 8(%rbx, %rax, 2), %rcx' | as -o temp.o && objdump -D -w  temp.o

48 8b 4c 43 08          mov    0x8(%rbx,%rax,2),%rcx

48：prefix (64bits)
8b: opcode (mov)
4c: ROM R/M (01 001 100)
   01xxx100: 1byte replacement & SIB
   001: target register rcx
43: SIB (01 000 011)
   01: scale 2
   000: index rax
   011: base rbx
08: replacement (0x8)

address = [rbx] + 2 * [rax] + 0x8



echo 'add %rcx, 17(%rbx, %rax, 4)' | as -o temp.o && objdump -D -w temp.o

48 01 4c 83 11          add    %rcx,0x11(%rbx,%rax,4)

48: prefix (64bits)
01: opcode (add)
4c: ROM R/M (01 001 100)
   01xxx100: 1 byte replacement & SIB
   001: rcx
83: SIB (10 000 011)
   10: scale 4
   000: index rax
   011: index rbx
11: replacement (0x11)

address = [rbx] + 4 * [rax] + 0x11

reference:  echo 'add 17(%rbx, %rax, 4),%rcx' | as -o temp.o && objdump -D -w temp.o

            48 03 4c 83 11          add    0x11(%rbx,%rax,4),%rcx

            the only diffence occurs in opcode, which differs from 01 to 03

re-reference:  echo 'add 17(%ebx, %eax, 4),%ecx' | as -o temp.o && objdump -D -w temp.o

               67 03 4c 83 11          add    0x11(%ebx,%eax,4),%ecx

               the only difference occurs in prefix, where 0x67 is used to addressing 32 bits register (EAX for example)

re-reference:  echo 'addl 17(%ebx, %eax, 4),%ecx' | as --32 -o temp.o && objdump -D -w temp.o

               03 4c 83 11             add    0x11(%ebx,%eax,4),%ecx

               prefix 0x67 would be removed if in 32-i386 mode

warning: you should use proper register with proper opcode. 
         ex. (add    0x11(%ebx,%eax,4),%ecx) or (addl   0x11(%ebx,%eax,4),%ecx) are allowed, but (addb 17(%rbx, %rax, 4),%rcx) is not



echo 'vfnmsub132ss %xmm3, %xmm2, %xmm1' | as -o temp.o && objdump -D -w temp.o

c4 e2 69 9f cb          vfnmsub132ss %xmm3,%xmm2,%xmm1

c4 e2 69: prefix (VEX 3-Byte)
9f: opcode (considering the prefix'e2 69' VFNMSUB132SS)
cb: MOD R/M (11 001 011)
   11: register-register
   001: xmm1
   011: xmm3

logic: xmm1 = (xmm1 * xmm3) - xmm2







x86 case

echo 'and $8, %al' | as --32 -o temp.o && objdump -D -w temp.o

24 08                   and    $0x8,%al

24: add to al
08: immediate operand 0x8



echo 'rep insb (%dx), %es:(%edi)' | as --32 -o temp.o && objdump -D -w temp.o

f3 6c                   rep insb (%dx),%es:(%edi)

f3: prefix (rep) 
6c: opcode



echo 'pop %ax' | as --32 -o temp.o && objdump -D -w temp.o

66 58                   pop    %ax

66: prefix (16bits data)
58: opcode