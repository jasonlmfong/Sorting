swap:
    slli x6, x11, 2     // reg x6 = k * 4
    add x6, x10, x6     // reg x6 = v + (k * 4)
    lw x5, 0(x6)        // reg x5 (temp) = v[k]
    lw x7, 4(x6)        // reg x7 = v[k + 1]
    sw x7, 0(x6)        // v[k] = reg x7
    sw x5, 4(x6)        // v[k+1] = reg x5 (temp)
    jalr x0, 0(x1)      // return to calling routine

sort:
    addi sp, sp, -20    //make room on the stack for 5 registers
    sw x1, 16(sp)       //save return address on stack
    sw x22, 12(sp)      //save x22 on the stack
    sw x21, 8(sp)       //save x21 on the stack
    sw x20, 4(sp)       //save x20 on the stack
    sw x19, 0(sp)       //save x19 on the stack
    
    addi x21, x10, 0    //copy parameter x10 to x21
    addi x22, x11, 0    //copy parameter x11 to x22

    addi x19, x0, 0     //i = 0
for1tst:
    bge x19, x22, exit1 //go to exit1 when i >= n
    addi x20, x19, -1   //j = i - 1
for2tst:
    blt x20, x0, exit2  //go to exit2 when j < 0
    slli x5, x20, 2     //x5 = j * 4
    add x5, x21, x5     //x5 = v + (j * 4)
    lw x6, 0(x5)        //x6 = v[j]
    lw x7, 4(x5)        //x7 = v[j + 1]
    ble x6, x7, exit2   //go to exit2 if x6< x7

    addi x10, x21, 0    //set first swap parameter to v
    addi x11, x20, 0    //set second swap paraeter to j
    jal x1, swap        //call swap

    addi x20, x20, -1   //j -= 1 for inner loop
    jal, x0 for2tst     //go to for2tst

exit2:
    addi x19, x19, 1    //i += 1 for outer loop
    jal, x0 for1tst     //go to for1tst

exit1:
    lw x19, 0(sp)       //restore x19 from the stack
    lw x20, 4(sp)       //restore x20 from the stack
    lw x21, 8(sp)       //restore x21 from the stack
    lw x22, 12(sp)      //restore x22 from the stack
    lw x1, 16(sp)       //restore return address from the stack
    addi sp, sp 20      restore the stack pointer and relieve 5 positions

    jalr x0, 0(x1)