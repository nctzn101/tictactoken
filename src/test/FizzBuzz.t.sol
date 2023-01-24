// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

// test contract for fizzbuzz

import "ds-test/test.sol";
import "../FizzBuzz.sol";
import "forge-std/Vm.sol";

import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract FizzBuzzTest is DSTest {
	Vm public constant vm = Vm(HEVM_ADDRESS);
	FizzBuzz internal fizzbuzz;

	function setUp() public { // instantiate the FizzBuzz contract
		fizzbuzz = new FizzBuzz();
	}

	function test_returns_fizz_when_divisible_by_three(uint256 n) public {
		vm.assume(n % 3 == 0); // filter out anything that's not divisible by 3
		vm.assume(n % 5 != 0); // filter out everything that is also divisible by 5 
		assertEq(fizzbuzz.fizzbuzz(n), "fizz");
	}

	function test_returns_fizz_when_divisible_by_five(uint256 n) public {
		vm.assume(n % 3 != 0); // filter out everything that is also divisible by 3
		vm.assume(n % 5 == 0); // filter out anything that's not divisible by 5
		assertEq(fizzbuzz.fizzbuzz(n), "buzz");
	}

	function test_returns_fizz_when_divisible_by_three_and_five(uint256 n) public {
		vm.assume(n % 3 == 0); // filter out anything that's not divisible by 3
		vm.assume(n % 5 == 0); // filter out anything that's not divisible by 5
		assertEq(fizzbuzz.fizzbuzz(n), "fizzbuzz");
	}

	function test_returns_number_as_string_otherwise(uint256 n) public {
		vm.assume(n % 3 != 0); // filter out everything that is also divisible by 3
		vm.assume(n % 5 != 0); // filter out everything that is also divisible by 5
		assertEq(fizzbuzz.fizzbuzz(n), Strings.toString(n));
	}

	


}