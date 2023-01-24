// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

// import code from external files
import "openzeppelin-contracts/contracts/access/Ownable.sol";

// the contract
contract Greeter is Ownable { // use inheritance
    string public greeting; // select variable visibility

    constructor(string memory _greeting) {
        greeting = _greeting;
    }

    function greet() public view returns (string memory) { // functions without arguments
        return _buildGreeting("world");
    }

    function greet(string memory name) public view returns (string memory) { // functions with arguments
        return _buildGreeting(name);
    }

    function setGreeting(string memory _greeting) public onlyOwner { 
        greeting = _greeting; // update variables
    }

    function _buildGreeting(string memory name) internal view returns (string memory) {
        return string(abi.encodePacked(greeting, ", ", name, "!")); // call internal functions
    }
}
