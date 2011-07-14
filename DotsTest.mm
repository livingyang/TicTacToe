//
//  DotsTest.m
//  TicTacToe
//
//  Created by lee living on 11-3-17.
//  Copyright 2011 LieHuo Tech. All rights reserved.
//

#import "DotsTest.h"
#import "DotsDef.h"
#import "DotsAlgorithm.h"

typedef struct
{
	int p1AreaCount;
	int p2AreaCount;
}DotsPlayerArea;

DotsPlayerArea GetAreaCount(DotsAlgorithm &alg, const DotsGameData &gameData)
{
	AreaInfoMap areaInfo;
	alg.GenerateAreaInfo(gameData, areaInfo);
	DotsPlayerArea area = {0, 0};
	
	for (AreaInfoMap::iterator iter = areaInfo.begin(); 
		 iter != areaInfo.end();
		 ++iter)
	{
		if ((*iter).second == true)
		{
			++area.p1AreaCount;
		}
		else
		{
			++area.p2AreaCount;
		}
	}
	
	return area;
}

@implementation DotsTest

- (void)testSimple
{
	STAssertTrue(1, @"");
}

- (void)testGameInit
{
	DotsGameData gameData;
	makeInitDotsData(gameData, 3, 3);
	
	STAssertTrue(gameData.isPlayer1Turn == true, @"");
	STAssertTrue(gameData.maxRow == 3, @"");
	STAssertTrue(gameData.maxColumn == 3, @"");
	STAssertTrue(gameData.dotsLineList.size() == 0, @"");
}

- (void)testMoveGen
{
	DotsAlgorithm alg;
	
	DotsGameData gameData;
	std::list<DotsLine> moveGen;
	
	makeInitDotsData(gameData, 2, 2);
	alg.GenerateMove(gameData, moveGen);
	STAssertTrue(moveGen.size() == 4, @"moveGen.size() == %d", moveGen.size());
	
	makeInitDotsData(gameData, 8, 7);
	alg.GenerateMove(gameData, moveGen);
	STAssertTrue(moveGen.size() == 97, @"moveGen.size() == %d", moveGen.size());
}

- (void)testMove
{
	DotsAlgorithm alg;
	
	DotsGameData gameData;
	std::list<DotsLine> moveGen;
	
	{
		makeInitDotsData(gameData, 2, 2);
		
		DotsLine move1 = {0, 1};
		gameData = alg.CreateSituation(gameData, move1);
		STAssertTrue(gameData.dotsLineList.size() == 1, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		DotsLine move2 = {2, 3};
		gameData = alg.CreateSituation(gameData, move2);
		STAssertTrue(gameData.dotsLineList.size() == 2, @"");
		STAssertTrue(gameData.isPlayer1Turn == true, @"");
		
		DotsLine move3 = {0, 2};
		gameData = alg.CreateSituation(gameData, move3);
		STAssertTrue(gameData.dotsLineList.size() == 3, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 0, @"");
			STAssertTrue(area.p2AreaCount == 0, @"");
		}
		
		DotsLine move4 = {1, 3};
		gameData = alg.CreateSituation(gameData, move4);
		STAssertTrue(gameData.dotsLineList.size() == 4, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 0, @"");
			STAssertTrue(area.p2AreaCount == 1, @"");
		}
	}
	
	{
		makeInitDotsData(gameData, 3, 3);
		
		DotsLine move1 = {0, 1};
		gameData = alg.CreateSituation(gameData, move1);
		STAssertTrue(gameData.dotsLineList.size() == 1, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		DotsLine move2 = {3, 4};
		gameData = alg.CreateSituation(gameData, move2);
		STAssertTrue(gameData.dotsLineList.size() == 2, @"");
		STAssertTrue(gameData.isPlayer1Turn == true, @"");
		
		DotsLine move3 = {0, 3};
		gameData = alg.CreateSituation(gameData, move3);
		STAssertTrue(gameData.dotsLineList.size() == 3, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 0, @"");
			STAssertTrue(area.p2AreaCount == 0, @"");
		}
		
		DotsLine move4 = {1, 4};
		gameData = alg.CreateSituation(gameData, move4);
		STAssertTrue(gameData.dotsLineList.size() == 4, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 0, @"");
			STAssertTrue(area.p2AreaCount == 1, @"");
		}
		
		DotsLine move5 = {1, 2};
		gameData = alg.CreateSituation(gameData, move5);
		STAssertTrue(gameData.dotsLineList.size() == 5, @"");
		STAssertTrue(gameData.isPlayer1Turn == true, @"");
		
		DotsLine move6 = {4, 5};
		gameData = alg.CreateSituation(gameData, move6);
		STAssertTrue(gameData.dotsLineList.size() == 6, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		DotsLine move7 = {2, 5};
		gameData = alg.CreateSituation(gameData, move7);
		STAssertTrue(gameData.dotsLineList.size() == 7, @"");
		STAssertTrue(gameData.isPlayer1Turn == false, @"");
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 0, @"");
			STAssertTrue(area.p2AreaCount == 2, @"");
		}
		
		{
			DotsLine move = {5, 8};
			gameData = alg.CreateSituation(gameData, move);
			STAssertTrue(gameData.dotsLineList.size() == 8, @"");
			STAssertTrue(gameData.isPlayer1Turn == true, @"");
		}
		
		{
			DotsLine move = {4, 7};
			gameData = alg.CreateSituation(gameData, move);
			STAssertTrue(gameData.dotsLineList.size() == 9, @"");
			STAssertTrue(gameData.isPlayer1Turn == false, @"");
		}
		
		{
			DotsLine move = {3, 6};
			gameData = alg.CreateSituation(gameData, move);
			STAssertTrue(gameData.dotsLineList.size() == 10, @"");
			STAssertTrue(gameData.isPlayer1Turn == true, @"");
		}
		
		{
			DotsLine move = {6, 7};
			gameData = alg.CreateSituation(gameData, move);
			STAssertTrue(gameData.dotsLineList.size() == 11, @"");
			STAssertTrue(gameData.isPlayer1Turn == true, @"");
		}
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 1, @"");
			STAssertTrue(area.p2AreaCount == 2, @"");
		}
		
		{
			DotsLine move = {7, 8};
			gameData = alg.CreateSituation(gameData, move);
			STAssertTrue(gameData.dotsLineList.size() == 12, @"");
			STAssertTrue(gameData.isPlayer1Turn == true, @"");
		}
		
		{
			DotsPlayerArea area = GetAreaCount(alg, gameData);
			STAssertTrue(area.p1AreaCount == 2, @"");
			STAssertTrue(area.p2AreaCount == 2, @"");
		}
	}
}

@end
