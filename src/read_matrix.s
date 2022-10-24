.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)        # s0 used for res
    sw s1, 8(sp)        # s1 used for rows
    sw s2, 12(sp)       # s2 used for cols
    sw s3, 16(sp)       # s3 used for fd

    mv s1, a1
    mv s2, a2

    # open file
    li a1, 0
    jal fopen
    li a1, -1
    beq a0, a1, error_fopen
    mv s3, a0

    # read rows
    mv a1, s1
    li a2, 4
    jal fread
    li a1, 4
    bne a1, a0, error_fread

    # read cols
    mv a0, s3
    mv a1, s2
    li a2, 4
    jal fread
    li a1, 4
    bne a1, a0, error_fread

    # cal total nums, s1 saved it
    lw s1, 0(s1)
    lw s2, 0(s2)
    mul s1, s1, s2

    # malloc
    mv a0, s1
    slli a0, a0, 2
    jal malloc
    beqz a0 error_malloc
    mv s0, a0

    # s2 used as index
    li s2, 0
    j loop_end

loop_begin:
    mv a0, s3
    slli a1, s2, 2
    add a1, s0, a1
    li a2, 4
    jal fread
    li a1, 4
    bne a0, a1, error_fread
    addi s2, s2, 1

loop_end:
    blt s2, s1, loop_begin

    # close file
    mv a0, s3
    jal fclose
    li a1, -1
    beq a0, a1, error_fclose

    # set ret flag
    mv a0, s0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    jr ra

error_fopen:
    li a0, 27
    j exit

error_fread:
    li a0, 29
    j exit

error_fclose:
    li a0, 28
    j exit

error_malloc:
    li a0, 26
    j exit