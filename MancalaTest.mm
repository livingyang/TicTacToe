//
//  MancalaTest.m
//  TicTacToe
//
//  Created by lee living on 11-3-15.
//  Copyright 2011 LieHuo Tech. All rights reserved.
//

#import "MancalaTest.h"
#import "MancalaDef.h"
#import "MancalaAlgorithm.h"

@implementation MancalaTest

- (void)testSimple
{
	STAssertTrue(1, @"");
}

- (void)testGameInit
{
	MancalaGameData gameData;
	makeInitMancalaData(gameData);
	
	STAssertTrue(gameData.isPlayer1Turn == true, @"");
	STAssertTrue(gameData.board.holes[STORE_PLAYER1] == 0, @"");
	STAssertTrue(gameData.board.holes[STORE_PLAYER2] == 0, @"");
	STAssertTrue(gameData.board.holes[3] == 4, @"");
	STAssertTrue(gameData.board.holes[12] == 4, @"");
}

- (void)testMove
{
	MancalaAlgorithm alg;
	
	MancalaGameData gameData = 
	{
		{
			4, 4, 4, 4, 4, 4, 0,
			4, 4, 4, 4, 4, 4, 0,
		},
		true,
	};
	
	std::list<int> moveGen;
	alg.GenerateMove(gameData, moveGen);
	STAssertTrue(moveGen.size() == 6, @"");
	
	{
		//第一次移动
		MancalaGameData movedData = 
		{
			{
				0, 5, 5, 5, 5, 4, 0,
				4, 4, 4, 4, 4, 4, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 0);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		//玩家2移动
		MancalaGameData movedData = 
		{
			{
				0, 5, 5, 5, 5, 4, 0,
				4, 4, 0, 5, 5, 5, 1,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 9);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
		
		alg.GenerateMove(gameData, moveGen);
		STAssertTrue(moveGen.size() == 5, @"");
	}
	
	{
		//玩家2再次移动
		MancalaGameData movedData = 
		{
			{
				1, 6, 6, 6, 5, 4, 0,
				4, 4, 0, 5, 5, 0, 2,
			},
			true,
		};
		
		gameData = alg.CreateSituation(gameData, 12);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
}

- (void)testCapture
{
	MancalaAlgorithm alg;
	
	{
		MancalaGameData gameData = 
		{
			{
				5, 0, 0, 0, 0, 0, 0,
				4, 4, 4, 4, 4, 4, 0,
			},
			true,
		};
		
		MancalaGameData movedData = 
		{
			{
				0, 1, 1, 1, 1, 0, 5,
				0, 4, 4, 4, 4, 4, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 0);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
}

- (void)testMoveLoop
{
	MancalaAlgorithm alg;
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 0, 0, 0, 0, 0, 0,
			},
			true,
		};
		
		MancalaGameData movedData = 
		{
			{
				1, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 5);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 8, 0,
				0, 0, 0, 0, 0, 0, 0,
			},
			true,
		};
		
		MancalaGameData movedData = 
		{
			{
				2, 0, 0, 0, 0, 0, 1,
				1, 1, 1, 1, 1, 1, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 5);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}	
	
	{
		MancalaGameData gameData = 
		{
			{
				0, 0, 0, 0, 0, 8, 0,
				0, 0, 0, 0, 0, 0, 0,
			},
			true,
		};
		
		MancalaGameData movedData = 
		{
			{
				0, 0, 0, 0, 0, 0, 3,
				1, 1, 1, 1, 1, 0, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 5);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		MancalaGameData gameData = 
		{
			{
				0, 0, 0, 13, 0, 0, 0,
				4, 4, 4, 4, 4, 4, 0,
			},
			true,
		};
		
		MancalaGameData movedData = 
		{
			{
				1, 1, 1, 0, 1, 1, 7,
				5, 5, 0, 5, 5, 5, 0,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 3);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
}

- (void)testP2Move
{
	MancalaAlgorithm alg;
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 4, 0, 0, 0, 0, 0,
			},
			false,
		};
		
		MancalaGameData movedData = 
		{
			{
				0, 0, 0, 0, 0, 7, 0,
				0, 0, 1, 1, 1, 0, 2,
			},
			true,
		};
		
		gameData = alg.CreateSituation(gameData, 8);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 5, 0, 0, 0, 0, 0,
			},
			false,
		};
		
		MancalaGameData movedData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 0, 1, 1, 1, 1, 1,
			},
			false,
		};
		
		gameData = alg.CreateSituation(gameData, 8);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 6, 0, 0, 0, 0, 0,
			},
			false,
		};
		
		MancalaGameData movedData = 
		{
			{
				2, 0, 0, 0, 0, 7, 0,
				0, 0, 1, 1, 1, 1, 1,
			},
			true,
		};
		
		gameData = alg.CreateSituation(gameData, 8);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
	
	{
		MancalaGameData gameData = 
		{
			{
				1, 0, 0, 0, 0, 7, 0,
				0, 0, 0, 0, 0, 9, 0,
			},
			false,
		};
		
		MancalaGameData movedData = 
		{
			{
				2, 1, 1, 1, 0, 8, 0,
				1, 0, 0, 0, 0, 0, 3,
			},
			true,
		};
		
		gameData = alg.CreateSituation(gameData, 12);
		STAssertTrue(memcmp(&movedData, &gameData, sizeof(gameData)) == 0, @"");
	}
}

- (void)testGameState
{
	MancalaAlgorithm alg;
	
	MancalaGameData p1WinData = 
	{
		{
			1, 0, 0, 0, 0, 7, 0,
			0, 0, 0, 0, 0, 0, 6,
		},
		false,
	};
	
	MancalaGameData p2WinData = 
	{
		{
			0, 0, 0, 0, 0, 0, 14,
			0, 0, 6, 5, 0, 0, 5,
		},
		false,
	};
	
	MancalaGameData drawData = 
	{
		{
			1, 0, 0, 0, 0, 7, 1,
			0, 0, 0, 0, 0, 0, 9,
		},
		false,
	};
	
	MancalaGameData unfinishData = 
	{
		{
			1, 0, 0, 0, 0, 7, 0,
			0, 0, 0, 0, 0, 9, 0,
		},
		false,
	};
	
	
	STAssertTrue(alg.GetMancalaBoardState(p1WinData.board) == P1Win_Mancala, @"");
	STAssertTrue(alg.GetMancalaBoardState(p2WinData.board) == P2Win_Mancala, @"");
	STAssertTrue(alg.GetMancalaBoardState(drawData.board) == Draw_Mancala, @"");
	STAssertTrue(alg.GetMancalaBoardState(unfinishData.board) == Unfinished_Mancala, @"");
}

@end
