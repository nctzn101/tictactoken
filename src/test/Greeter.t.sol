// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../Greeter.sol";

// test suite defined as a Solidity contract (~class/module in other languages)
contract GreeterTest is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);

    Greeter internal greeter;

    // create instance of the contract to access it later in tests
    function setUp() public { 
        greeter = new Greeter("Hello");
    }

    // tests are public functions prefixed with the term 'test'
    function test_default_greeting() public {
        // inside these functions we have access to assertions
       assertEq(greeter.greet(), "Hello, world!");
    }
    
    function test_custom_greeting() public {
       assertEq(greeter.greet("foundry"), "Hello, foundry!");
    }

    function test_get_greeting() public {
        assertEq(greeter.greeting(), "Hello");
    }
    
    function test_set_greeting() public {
        greeter.setGreeting("Ahoy-hoy");
        assertEq(greeter.greet(), "Ahoy-hoy, world!");
    }

    function test_non_owner_cannot_set_greeting() public {
        vm.prank(address(1));
        try greeter.setGreeting("Ahoy-hoy") {
            fail();
        } catch Error(string memory message) {
            assertEq(message, "Ownable: caller is not the owner");
        }
    }
}
