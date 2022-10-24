.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # check error
    bge zero, a2, error_code_length
    bge zero, a3, error_code_stride
    bge zero, a4, error_code_stride

    # main status
    li a5, 0            # a5 = res = 0
    li t0, 0            # t0 = ai = 0
    li t1, 0            # t1 = bi = 0
    li t2, 0            # t2 = i  = 0
    j loop_end

loop_start:
    slli t3, t0, 2
    add t3, a0, t3
    lw t3, 0(t3)
    slli t4, t1, 2
    add t4, a1, t4
    lw t4, 0(t4)
    mul t3, t3, t4
    add a5, t3, a5
    add t0, t0, a3
    add t1, t1, a4
    addi t2, t2, 1

loop_end:
    blt t2, a2, loop_start
    add a0, a5, zero
    jr ra

error_code_length:
    li a0, 36
    j exit

error_code_stride:
    li a0, 37
    j exit
