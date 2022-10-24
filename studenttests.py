import sys
import unittest
from framework import AssemblyTest, print_coverage, _venus_default_args
from tools.check_hashes import check_hashes

"""
Coverage tests for project 2 is meant to make sure you understand
how to test RISC-V code based on function descriptions.
Before you attempt to write these tests, it might be helpful to read
unittests.py and framework.py.
Like project 1, you can see your coverage score by submitting to gradescope.
The coverage will be determined by how many lines of code your tests run,
so remember to test for the exceptions!
"""

"""
abs_loss
# =======================================================
# FUNCTION: Get the absolute difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the absolute loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestAbsLoss(unittest.TestCase):
    def doAbsLoss(self, array0, array1, length, result_array, result, code=0):
        t = AssemblyTest(self, "../coverage-src/abs_loss.s")

        # load address of input arrays and set their dimension
        t.input_array("a0", t.array(array0))
        t.input_array("a1", t.array(array1))
        t.input_scalar("a2", length)
        output_array = t.array([-1] * len(array0))
        # load address of output array
        t.input_array("a3", output_array)

        # call the `abs_loss` function
        t.call("abs_loss")
        t.check_array(output_array, result_array)
        t.check_scalar("a0", result)
        t.execute(code=code)


    def test_abs_loss_standard(self):
        self.doAbsLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [0, 4, 2, 2, 4, 0, 6, 2, 8],
            28,
        )

    def test_abs_loss_length_0(self):
        self.doAbsLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            0,
            [0, 4, 2, 2, 4, 0, 6, 2, 8],
            28,
            code=36,
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs_loss.s", verbose=False)


"""
squared_loss
# =======================================================
# FUNCTION: Get the squared difference of 2 int arrays,
#   store in the result array and compute the sum
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   a0 (int)  is the sum of the squared loss
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestSquaredLoss(unittest.TestCase):
    def doSquaredLoss(self, array0, array1, length, result_array, result, code=0):
        t = AssemblyTest(self, "../coverage-src/squared_loss.s")

        # load address of input arrays and set their dimension
        t.input_array("a0", t.array(array0))
        t.input_array("a1", t.array(array1))
        t.input_scalar("a2", length)
        output_array = t.array([-1] * len(array0))
        # load address of output array
        t.input_array("a3", output_array)

        # call the `squared_loss` function
        t.call("squared_loss")
        t.check_array(output_array, result_array)
        t.check_scalar("a0", result)
        t.execute(code=code)


    def test_squared_loss_standard(self):
        self.doSquaredLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [0, 16, 4, 4, 16, 0, 36, 4, 64],
            144,
        )

    def test_squared_loss_length_0(self):
        self.doSquaredLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            0,
            [0, 16, 4, 4, 16, 0, 36, 4, 64],
            144,
            code=36,
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("squared_loss.s", verbose=False)


"""
zero_one_loss
# =======================================================
# FUNCTION: Generates a 0-1 classifer array inplace in the result array,
#  where result[i] = (arr0[i] == arr1[i])
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the length of the arrays
#   a3 (int*) is the pointer to the start of the result array

# Returns:
#   NONE
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# =======================================================
"""


class TestZeroOneLoss(unittest.TestCase):
    def doZeroOneLoss(self, array0, array1, length, result_array, code=0):
        t = AssemblyTest(self, "../coverage-src/zero_one_loss.s")

        # load address of input arrays and set their dimension
        t.input_array("a0", t.array(array0))
        t.input_array("a1", t.array(array1))
        t.input_scalar("a2", length)
        output_array = t.array([-1] * len(array0))
        # load address of output array
        t.input_array("a3", output_array)

        # call the `zero_one_loss` function
        t.call("zero_one_loss")
        t.check_array(output_array, result_array)
        t.execute(code=code)


    def test_zero_one_loss_standard(self):
        self.doZeroOneLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            9,
            [1, 0, 0, 0, 0, 1, 0, 0, 0],
        )

    def test_zero_one_loss_length_0(self):
        self.doZeroOneLoss(
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [1, 6, 1, 6, 1, 6, 1, 6, 1],
            0,
            [1, 0, 0, 0, 0, 1, 0, 0, 0],
            code=36,
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("zero_one_loss.s", verbose=False)


"""
initialize_zero
# =======================================================
# FUNCTION: Initialize a zero array with the given length
# Arguments:
#   a0 (int) size of the array

# Returns:
#   a0 (int*)  is the pointer to the zero array
# Exceptions:
# - If the length of the array is less than 1,
#   this function terminates the program with error code 36.
# - If malloc fails, this function terminates the program with exit code 26.
# =======================================================
"""


class TestInitializeZero(unittest.TestCase):
    def test_initialize_zero_standard(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        length = 5
        # set a0 to the length of malloc array
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        # check that the array was initialize appropriately
        t.check_array_pointer("a0", [0] * length)
        t.execute()
    
    def test_initialize_zero_length_0(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        length = 0
        # set a0 to the length of malloc array
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        t.execute(code=36)
    
    def test_initialize_zero_malloc_error(self):
        t = AssemblyTest(self, "../coverage-src/initialize_zero.s")

        length = 1073741824
        # set a0 to the length of malloc array
        t.input_scalar("a0", length)
        # call the `initialize_zero` function
        t.call("initialize_zero")
        t.execute(code=26)
    

    @classmethod
    def tearDownClass(cls):
        print_coverage("initialize_zero.s", verbose=False)


if __name__ == "__main__":
    split_idx = sys.argv.index("--")
    for arg in sys.argv[split_idx + 1 :]:
        _venus_default_args.append(arg)

    check_hashes()

    unittest.main(argv=sys.argv[:split_idx])
