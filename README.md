# tictactoken
following the curriculum at https://book.tictactoken.co/

# skills learned
	- basics of Solidity and Ethereum
	- write and test Solidity smart contracts with Foundry and Hardhat
	- explore ERC20 tokens, NFTs
	- create React frontend using useDapp and Ethers
	- deploy frontend to IPFS
	- deploy contract to Polygon

# prerequisites 
	[todo] Mastering Ethereum chapters 1-6
	[todo] 101 React
	[todo] 102 automated testing
	[check] 102 UNIX
	[check] used both dynamic and typed programming languages


## week 1
	[] setup Solidity environment using Foundry
	[] write and run tests using `forge`
	[] explore Solidity syntax
	[] read through the Basics and Language Description of the Solidity documentation
	[] implement one TDD kata (https://kata-log.rocks/tdd) in Solidity






# Resources
## Solidity
- [Solidity documentation](https://docs.soliditylang.org/)

## Foundry
- [How to Foundry](https://www.youtube.com/watch?v=Rp_V7bYiTCM)
- The [Foundry Book](https://book.getfoundry.sh/)
- run `foundryup` to install latest updates
- `cast --to-ascii [address]`
- `forge` manage projects, compile contracts, run tests
- `forge init [PROJECT_NAME]` creates new project from a template

### foundry directory
- `foundry.toml` configuration file
- `lib/` project dependencies directory
	- `ds-test` unit testing framework
- `src/` for Solidity contracts, including tests
	- `test/` directory for unit test contracts (`.t.sol` extension) 
- `forge test` compiles the project and runs the tests
- run property-based tests to cover all edge cases:
	forge interprets any unit test function that takes an argument as a property based test and run it multiple times with randomly assigned values

##