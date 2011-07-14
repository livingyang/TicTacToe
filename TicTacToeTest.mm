//
//  TicTacToeTest.m
//  TicTacToe
//
//  Created by lee living on 11-3-11.
//  Copyright 2011 LieHuo Tech. All rights reserved.
//

#import "TicTacToeTest.h"
#import "TicTacToeDef.h"
#import "TicTacToeAlgorithm.h"

@implementation TicTacToeTest

- (void)testSimple
{
	STAssertTrue(1, @"");
}

- (void)testGameLogic
{
	TicTacToeAlgorithm algo;
	
	TicTacToeGameData gameData;
	makeInitTicTacToeData(gameData);
	
	STAssertTrue(gameData.isPlayer1Turn == true, @"");
	for (int i = 0; i < 9; ++i)
	{
		STAssertTrue(gameData.board.pieces[i] == None_Piece, @"");
	}

	//测试胜利判断
	TicTacToeGameData p1WinData = 
	{
		{
			None_Piece, Piece1, Piece1,
			None_Piece, Piece1, Piece1,
			None_Piece, Piece1, Piece1,
		},
		true,
	};
	
	TicTacToeGameData p2WinData = 
	{
		{
			None_Piece, Piece1, Piece1,
			Piece2, Piece2, Piece2,
			None_Piece, Piece1, Piece1,
		},
		true,
	};	
	
	TicTacToeGameData noWinData1 = 
	{
		{
			None_Piece, Piece1, Piece1,
			Piece2, None_Piece, Piece2,
			None_Piece, Piece1, Piece1,
		},
		true,
	};
	
	TicTacToeGameData drawGame = 
	{
		{
			Piece1, Piece2, Piece1,
			Piece2, Piece1, Piece2,
			Piece2, Piece1, Piece2,
		},
		true,
	};
	
	TicTacToeGameData testData = 
	{
		{
			Piece2, Piece1, Piece2,
			Piece1, Piece1, None_Piece,
			Piece2, Piece2, Piece1,
		},
		false,
	};
	
	//测试游戏胜利事件
	STAssertTrue(algo.GetTicTacToeBoardState(p1WinData.board) == P1Win, @"");
	STAssertTrue(algo.GetTicTacToeBoardState(p2WinData.board) == P2Win, @"");
	STAssertTrue(algo.GetTicTacToeBoardState(noWinData1.board) == Unfinished, @"");
	STAssertTrue(algo.GetTicTacToeBoardState(drawGame.board) == Draw, @"");
	STAssertTrue(algo.GetTicTacToeBoardState(testData.board) == Unfinished, @"");
	
	//测试游戏的着法生成器
	std::list<int> moveGen;
	algo.GenerateMove(p1WinData, moveGen);
	STAssertTrue(moveGen.size() == 0, @"");
	algo.GenerateMove(p2WinData, moveGen);
	STAssertTrue(moveGen.size() == 0, @"");
	algo.GenerateMove(noWinData1, moveGen);
	STAssertTrue(moveGen.size() == 3, @"");
	algo.GenerateMove(drawGame, moveGen);
	STAssertTrue(moveGen.size() == 0, @"");

	
	{
		TicTacToeGameData data1 = 
		{
			{
				None_Piece, None_Piece, Piece1,
				None_Piece, None_Piece, None_Piece,
				None_Piece, None_Piece, None_Piece,
			},
			true,
		};
		
		TicTacToeGameData data2 = 
		{
			{
				Piece2, None_Piece, Piece1,
				None_Piece, None_Piece, None_Piece,
				None_Piece, None_Piece, None_Piece,
			},
			true,
		};
		
		STAssertTrue(algo.GetSituationMinimaxValue(data1, 1) == 3, @"");
		STAssertTrue(algo.GetSituationMinimaxValue(data2, 1) == 0, @"");
	}
	
	//测试局面生成器
	{		
		TicTacToeGameData data = 
		{
			{
				Piece2, None_Piece, Piece1,
				None_Piece, None_Piece, None_Piece,
				Piece2, None_Piece, Piece1,
			},
			true,
		};
		
		//测试玩家1胜利
		TicTacToeGameData p1Win = algo.CreateSituation(data, 5);
		STAssertTrue(p1Win.isPlayer1Turn == false, @"");
		
		//测试玩家2胜利
		TicTacToeGameData p2Win = algo.CreateSituation(data, 4);
		STAssertTrue(p2Win.isPlayer1Turn == false, @"");
		
		p2Win = algo.CreateSituation(p2Win, 3);
		STAssertTrue(p2Win.isPlayer1Turn == true, @"");
	}
}

@end
