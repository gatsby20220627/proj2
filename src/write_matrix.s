.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a1       # s0 == *matrix
    mv s1, a2       # s1 == rows
    mv s2, a3       # s2 == cols

    li a1, 1
    jal fopen
    li a1, -1
    beq a0, a1, error_fopen
    mv s3, a0

    # write rows and cols
    addi sp, sp, -8
    sw s1, 0(sp)
    sw s2, 4(sp)
    mv a1, sp
    li a2, 2
    li a3, 4
    jal fwrite
    li a2, 2
    bne a0, a2, error_fwrite
    addi sp, sp, 8

    # write all datas
    mv a0, s3
    mv a1, s0
    mul a2, s1, s2
    li a3, 4
    jal fwrite
    mul a1, s1, s2
    bne a0, a1, error_fwrite
    
    mv a0, s3
    jal fclose
    li a1, -1
    beq a0, a1, error_fclose

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

error_fclose:
    li a0, 28
    j exit

error_fwrite:
    li a0, 30
    j exit
