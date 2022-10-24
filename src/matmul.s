.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    bge zero, a1, error_code
    bge zero, a2, error_code
    bge zero, a4, error_code
    bge zero, a5, error_code
    bne a2, a4, error_code

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    mv s0, a0       # a
    mv s1, a3       # b
    mv s2, a6       # c
    mv s3, a1       # ah
    mv s4, a5       # bw
    mv s5, a2       # aw (equals bh)

    li t0, 0        # t0 = i, [0, s3)
    j outer_loop_end

outer_loop_start:
    li t1, 0        # t1 = j, [0, s4)
    j inner_loop_end



inner_loop_start:
    # i, j is determined, so cal dot
    mul a0, t0, s5
    slli a0, a0, 2
    add a0, s0, a0
    slli a1, t1, 2
    add a1, s1, a1
    mv a2, s5
    li a3, 1
    mv a4, s4

    addi sp, sp, -8
    sw t0, 0(sp)
    sw t1, 4(sp)

    call dot

    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8

    mul a1, t0, s4
    add a1, a1, t1
    slli a1, a1, 2
    add a1, a1, s2
    sw a0, 0(a1)

    addi t1, t1, 1

inner_loop_end:
    blt t1, s4, inner_loop_start
    addi t0, t0, 1

outer_loop_end:
    blt t0, s3, outer_loop_start

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    jr ra

error_code:
    li a0, 38
    j exit
