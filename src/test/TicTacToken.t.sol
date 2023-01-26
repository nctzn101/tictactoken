//SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "../TicTacToken.sol";


// create mock user (instead of using prank)
	// helper contract acts as a mock user in the tests
contract User {
	TicTacToken internal ttt;
	Vm internal vm;
	address internal _address;

	constructor(address address_, TicTacToken _ttt, Vm _vm) {
		_address = address_;
		ttt = _ttt;
		vm = _vm;
	}

	function markSpace(uint256 space) public {
		vm.prank(_address); // set the caller address to the internal address
		ttt.markSpace(space);//, symbol);
	}
}

// explore how msg.sender changes based on current caller
contract Caller {

	TicTacToken internal ttt; 

	constructor(TicTacToken _ttt) {
		ttt = _ttt;
	}

	function call() public view returns (address) {
		return ttt.msgSender();
	}
}

contract TicTacTokenTest is DSTest {
	Vm internal vm = Vm(HEVM_ADDRESS);
	TicTacToken internal ttt;

	// authorize owner/players
	address internal constant OWNER = address(1);
	address internal constant PLAYER_X = address(2);
	address internal constant PLAYER_O = address(3);

	User internal playerX;
	User internal playerO;

	uint256 internal constant EMPTY = 0;
	uint256 internal constant X = 1;
	uint256 internal constant O = 2;

	// instantiate a new game
	function setUp() public {
		ttt = new TicTacToken(OWNER, PLAYER_X, PLAYER_O);
		playerX = new User(PLAYER_X, ttt, vm);
		playerO = new User(PLAYER_O, ttt, vm);
	}

	function test_has_empty_board() public {
		for (uint256 i=0; i<9; i++) {
			assertEq(ttt.board(i), EMPTY); // verify that board is empty at position
		}
	}

	// verify the status of the entire board all at once
	function test_get_board() public {
		uint256[9] memory expected = [EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY];
		uint256[9] memory actual = ttt.getBoard();

		for (uint256 i=0; i<9; i++) {
			assertEq(actual[i], expected[i]);
		}

	}

	// no longer to pass symbol - it can be inferred from the caller address
	function test_can_mark_X() public {
		//ttt.markSpace(0, X);
		playerX.markSpace(0); //, X);
		assertEq(ttt.board(0), X);
	}

	function test_can_mark_O() public {
		// ttt.markSpace(0, X);
		// ttt.markSpace(1, O);
		playerX.markSpace(0);//, X);
		playerO.markSpace(1);//, O);
		assertEq(ttt.board(1), O);
	}

	// no longer relevant test
	// function test_cannot_mark_space_with_other_char() public {
	// 	vm.expectRevert("Invalid symbol");
	// 	//ttt.markSpace(0, 3);
	// 	playerX.markSpace(0);//, 3);
	// }

	function test_cannot_overwrite_marked_space() public {
		//ttt.markSpace(0, X);
		playerX.markSpace(0);//, X);

		vm.expectRevert("Already marked"); // vm.expectRevert must be placed directly above the line we expect to error
		//ttt.markSpace(0, O);
		playerO.markSpace(0);//, O);
	}

	function test_symbols_must_alternate() public {
		//ttt.markSpace(0, X);
		playerX.markSpace(0);//, X);

		vm.expectRevert("Not your turn");
		//ttt.markSpace(1, X);
		// playerX or playerO?
		playerX.markSpace(1);//, X);
	}

	function test_track_current_turn() public {
		assertEq(ttt.currentTurn(), X);
		//ttt.markSpace(0, X);
		playerX.markSpace(0);//, X);
		assertEq(ttt.currentTurn(), O);
		playerO.markSpace(1);//, O);
		//ttt.markSpace(1, O);
		assertEq(ttt.currentTurn(), X);

	}


	// test horizontal win
	// intercalated so it won't fail turns test
	function test_checks_horizontal_win() public {
		playerX.markSpace(0);//, X);
		playerO.markSpace(3);//, O);
		playerX.markSpace(1);//, X);
		playerO.markSpace(4);//, O);
		playerX.markSpace(2);//, X);
		// ttt.markSpace(0, X);
		// ttt.markSpace(3, O);
		// ttt.markSpace(1, X);
		// ttt.markSpace(4, O);
		// ttt.markSpace(2, X);
		assertEq(ttt.winner(), X);
	}

	function test_checks_horizontal_win_row2() public {
	    // ttt.markSpace(3, X);
	    // ttt.markSpace(0, O);
	    // ttt.markSpace(4, X);
	    // ttt.markSpace(1, O);
	    // ttt.markSpace(5, X);
	    playerX.markSpace(3);//, X);
		playerO.markSpace(0);//, O);
		playerX.markSpace(4);//, X);
		playerO.markSpace(1);//, O);
		playerX.markSpace(5);//, X);
	    assertEq(ttt.winner(), X);
  }
  	function test_checks_for_vertical_win() public {
	    // ttt.markSpace(1, X);
	    // ttt.markSpace(0, O);
	    // ttt.markSpace(2, X);
	    // ttt.markSpace(3, O);
	    // ttt.markSpace(4, X);
	    // ttt.markSpace(6, O);
	    playerX.markSpace(1);//, X);
		playerO.markSpace(0);//, O);
		playerX.markSpace(2);//, X);
		playerO.markSpace(3);//, O);
		playerX.markSpace(4);//, X);
		playerO.markSpace(6);//, O);
	    assertEq(ttt.winner(), O);
  }

  	function test_draw_returns_no_winner() public {
  		// ttt.markSpace(0, X);
	   //  ttt.markSpace(4, O);
	   //  ttt.markSpace(2, X);
	   //  ttt.markSpace(1, O);
	   //  ttt.markSpace(7, X);
	   //  ttt.markSpace(8, O);
	   //  ttt.markSpace(3, X);
	   //  ttt.markSpace(6, O);
	   //  ttt.markSpace(5, X);
	    playerX.markSpace(0);//, X);
		playerO.markSpace(4);//, O);
		playerX.markSpace(2);//, X);
		playerO.markSpace(1);//, O);
		playerX.markSpace(7);//, X);
		playerO.markSpace(8);//, O);
		playerX.markSpace(3);//, X);
		playerO.markSpace(6);//, O);
		playerX.markSpace(5);//, X);
	    assertEq(ttt.winner(), EMPTY);
  	}

  	function test_empty_board_returns_no_winner() public {
  		assertEq(ttt.winner(), EMPTY);
  	}

  	function test_game_in_progress_returns_no_winner() public {
  		//ttt.markSpace(1, X);
  		playerX.markSpace(1);//, X);
  		assertEq(ttt.winner(), EMPTY);
  	}

  	function test_check_diagonal_win() public {
  		// ttt.markSpace(0, X);
	   //  ttt.markSpace(1, O);
	   //  ttt.markSpace(4, X);
	   //  ttt.markSpace(2, O);
	   //  ttt.markSpace(8, X);
	    playerX.markSpace(0);//, X);
		playerO.markSpace(1);//, O);
		playerX.markSpace(4);//, X);
		playerO.markSpace(2);//, O);
		playerX.markSpace(8);//, X);
	    assertEq(ttt.winner(), X);
  	}

  	function test_check_antidiagonal_win() public {
  		// ttt.markSpace(2, X);
	   //  ttt.markSpace(1, O);
	   //  ttt.markSpace(4, X);
	   //  ttt.markSpace(3, O);
	   //  ttt.markSpace(6, X);
	    playerX.markSpace(2);//, X);
		playerO.markSpace(1);//, O);
		playerX.markSpace(4);//, X);
		playerO.markSpace(3);//, O);
		playerX.markSpace(6);//, X);
	    assertEq(ttt.winner(), X);
  	}

  	function test_msg_sender() public {

  		// create two callers
  		Caller caller1 = new Caller(ttt);
  		Caller caller2 = new Caller(ttt);


        assertEq(ttt.msgSender(), address(this));

        assertEq(caller1.call(), address(caller1));
        assertEq(caller2.call(), address(caller2));
    }

    function test_contract_owner() public {
    	assertEq(ttt.owner(), OWNER);
    }

    function test_owner_can_reset_board() public {
    	vm.prank(OWNER);
    	ttt.resetBoard();
    }

    function test_non_owner_cannot_reset_board() public {
    	vm.expectRevert("Unauthorized");
    	ttt.resetBoard();
    }

    function test_reset_board() public {
    	// ttt.markSpace(3, X);
    	// ttt.markSpace(0, O);
    	// ttt.markSpace(4, X);
    	// ttt.markSpace(1, O);
    	// ttt.markSpace(5, X);
    	playerX.markSpace(3);//, X);
		playerO.markSpace(0);//, O);
		playerX.markSpace(4);//, X);
		playerO.markSpace(1);//, O);
		playerX.markSpace(5);//, X);
    	vm.prank(OWNER);
    	ttt.resetBoard();

    	uint256[9] memory expected = [EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY];
    	uint256[9] memory actual = ttt.getBoard();

    	for (uint256 i = 0; i < 9; i++) {
    		assertEq(actual[i], expected[i]);
    	}

    }

    function test_stores_player_X() public {
    	assertEq(ttt.playerX(), PLAYER_X);
    }

    function test_stores_player_O() public {
    	assertEq(ttt.playerO(), PLAYER_O);
    }

    function test_auth_nonplayer_cannot_mark_space() public {
    	vm.expectRevert("Unauthorized");
    	ttt.markSpace(0);//, X);
    }

    function test_auth_playerX_can_mark_space() public {
    	vm.prank(PLAYER_X);
    	ttt.markSpace(0);//, X);
    }

    function test_auth_playerO_can_mark_space() public {
    	vm.prank(PLAYER_X);
    	ttt.markSpace(0);//, X);

    	vm.prank(PLAYER_O);
    	ttt.markSpace(1);//, O);
    }
}