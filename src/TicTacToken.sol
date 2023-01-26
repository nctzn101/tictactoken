//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;


contract TicTacToken {

	uint256[9] public board; // fixed size array of 9 spaces
		// public -> generates the board(i) getter

	uint256 internal constant EMPTY = 0;
	uint256 internal constant X = 1;
	uint256 internal constant O = 2;
	uint256 internal _turns;

	address public owner;
	address public playerX;
	address public playerO;

	constructor(address _owner, address _playerX, address _playerO) {
		owner = _owner;
		playerX = _playerX;
		playerO = _playerO;
	}

	// these were not in the tutorial
	function msgSender() public view returns (address) {
		return msg.sender;
	}
	// till here

	// view -> read-only
	function getBoard() public view returns (uint256[9] memory) {
		return board;
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "Unauthorized");
		_;
	}

	modifier onlyPlayer() {
		require(_validPlayer(), "Unauthorized");
		_;
	}

	// calldata represents the location for symbol; calldata - immutable area where function args are stored
	function markSpace(uint256 space) public onlyPlayer {//, uint256 symbol) public {
		uint256 symbol = _getSymbol();
		////require(_validPlayer(), "Unauthorized");
		//require(_validSymbol(symbol), "Invalid symbol");
		require(_validTurn(symbol), "Not your turn");
		require(_spaceClear(space), "Already marked");


		//require(_compareStrings(board[space], ""), "Already marked"); // refactored
		//require(_compareStrings(symbol, "X") || _compareStrings(symbol, "O"), "Invalid symbol"); // refactored
		board[space] = symbol;
		_turns++;

	}

	function _getSymbol() public view returns (uint256) {
		if (msg.sender == playerX) return X;
		if (msg.sender == playerO) return O;
		return EMPTY;
	}

	// display current turn publicly
	function currentTurn() public view returns (uint256) { //(string memory) {
		return (_turns % 2 == 0) ? X : O;
	}

	// view - because it reads from the board so it's not pure
	function _spaceClear(uint256 space) internal view returns (bool) {
		return board[space] == EMPTY; // _compareStrings(board[space], EMPTY);
	} 

	//

	function _validPlayer() internal view returns (bool) {
		return msg.sender == playerX || msg.sender == playerO;
	}

	// internal helper
	// pure - doesn't read/write any state
	// prefixed with _, which is the preferred style for internal and private functions
	// function _compareStrings(string memory a, string memory b) internal pure returns (bool) {
	// 	return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
	// }

	function _validTurn(uint256 symbol) internal view returns (bool) {
		// "X" goes when counter is even, "O" goes when counter is odd
		// if yes (even) - X, if no - O
		//return symbol == currentTurn(); //(_turns % 2 == 0) ? _compareStrings(symbol, X) :_compareStrings(symbol, O);
		return currentTurn() == _getSymbol();
	}

	// iterate over every combo
	function winner() public view returns (uint256) {
		uint256[8] memory wins = [
			_row(0),
			_row(1),
			_row(2),
			_col(0),
			_col(1),
			_col(2),
			_diag(),
			_antiDiag()
		];
		for (uint256 i; i < wins.length; i++) {
			uint256 win = _checkWin(wins[i]); // check wether there's a win at the given row
			if (win == X || win == O) return win;
		}
		return 0;
	}


	// get row product: 1 * 1 * 1 = 1; 2 * 2 * 2 = 8
	function _row(uint256 row) internal view returns (uint256) {
		require(row < 3, "Invalid row");
		uint256 idx = 3 * row; // so idx is either 0, 3, or 6
		return board[idx] * board[idx+1] * board[idx+2];
	}

	function _col(uint256 col) internal view returns (uint256) {
		require(col < 3, "Invalid column");
		return board[col] * board[col+3] * board[col+6];
	}

	function _checkWin(uint256 product) internal pure returns (uint256) {
		if (product == 1) {
			return X;
		}
		if (product == 8) {
			return O;
		}
		return 0;
	}

	// check the diagonals
	function _diag() internal view returns (uint256) {
		return board[0] * board[4] * board[8];
	}

	function _antiDiag() internal view returns (uint256) {
		return board[2] * board[4] * board[6];
	}

	function resetBoard() public onlyOwner {
		// require(
		// 	// any owner can reset the board
		// 	msg.sender == owner, "Unauthorized"
		// 	);
		delete board;
	}
}