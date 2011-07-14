/*
 *  MancalaAlgorithm.cpp
 *  TicTacToe
 *
 *  Created by lee living on 11-3-15.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#include "MancalaAlgorithm.h"

#include <algorithm>

void MancalaAlgorithm::GenerateMove(const MancalaGameData &situaData, std::list<int> &moveList)
{
	moveList.clear();
	
	if (IsGameOver(situaData))
	{
		return;
	}
	
	int searchPriority[6];
	if (situaData.isPlayer1Turn)
	{
		int priority[6] = {0, 1, 2, 3, 4, 5};
		memcpy(searchPriority, priority, sizeof(priority));
	}
	else
	{
		int priority[6] = {7, 8, 9, 10, 11, 12};
		memcpy(searchPriority, priority, sizeof(priority));
	}
	
	if (m_SearchModel == MAN_SER_RANDOM)
	{
		std::random_shuffle(searchPriority, searchPriority + 6);
	}
	
	for (int i = 0; i < 6; ++i)
	{
		if (situaData.board.holes[searchPriority[i]] != 0)
		{
			moveList.push_back(searchPriority[i]);
		}
	}
}

MancalaGameData MancalaAlgorithm::CreateSituation(const MancalaGameData &situaData, const int &moveData)
{
	MancalaGameData movedSituation = situaData;
	
	if ((moveData >= 0 && moveData < MAX_HOLE_COUNT) &&
		(moveData != STORE_PLAYER1 && moveData != STORE_PLAYER2) &&
		(movedSituation.board.holes[moveData] > 0))
	{
		int lastMovedHole = moveData;
		
		int seeds = movedSituation.board.holes[moveData];
		movedSituation.board.holes[moveData] = 0;
		
		for (; seeds > 0; --seeds)
		{
			if (lastMovedHole == STORE_PLAYER2)
			{
				lastMovedHole = 0;
			}
			else if (lastMovedHole == STORE_PLAYER1 - 1)
			{
				if (movedSituation.isPlayer1Turn)
				{
					++lastMovedHole;
				}
				else
				{
					lastMovedHole += 2;
				}
			}
			else if (lastMovedHole == STORE_PLAYER2 - 1)
			{
				if (movedSituation.isPlayer1Turn)
				{
					lastMovedHole = 0;
				}
				else
				{
					++lastMovedHole;
				}
			}
			else
			{
				++lastMovedHole;
			}

			++movedSituation.board.holes[lastMovedHole];
		}
		
		if ((lastMovedHole == STORE_PLAYER1 && movedSituation.isPlayer1Turn == true) ||
			(lastMovedHole == STORE_PLAYER2 && movedSituation.isPlayer1Turn == false))
		{
			//不切换玩家
		}
		else
		{
			//处理捕获，并且切换玩家
			if (lastMovedHole >= 0 && lastMovedHole < STORE_PLAYER1 && 
				movedSituation.isPlayer1Turn &&
				movedSituation.board.holes[lastMovedHole] == 1 &&
				movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2] > 0)
			{
				//玩家1的捕获
				movedSituation.board.holes[STORE_PLAYER1] += movedSituation.board.holes[lastMovedHole];
				movedSituation.board.holes[STORE_PLAYER1] += movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2];
				
				movedSituation.board.holes[lastMovedHole] = 0;
				movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2] = 0;
			}
			else if (lastMovedHole > STORE_PLAYER1 && lastMovedHole < STORE_PLAYER2 && 
					 movedSituation.isPlayer1Turn == false &&
					 movedSituation.board.holes[lastMovedHole] == 1 &&
					 movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2] > 0)
			{
				//玩家2的捕获
				movedSituation.board.holes[STORE_PLAYER2] += movedSituation.board.holes[lastMovedHole];
				movedSituation.board.holes[STORE_PLAYER2] += movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2];
				
				movedSituation.board.holes[lastMovedHole] = 0;
				movedSituation.board.holes[MAX_HOLE_COUNT - lastMovedHole - 2] = 0;
			}

			
			movedSituation.isPlayer1Turn = !movedSituation.isPlayer1Turn;
		}

	}

	return movedSituation;
}

int MancalaAlgorithm::GetSituationMinimaxValue(const MancalaGameData &situaData, int depth)
{
	int minimaxValue = 0;
	
	if (GetMancalaBoardState(situaData.board) == Unfinished_Mancala)
	{
		minimaxValue = situaData.board.holes[STORE_PLAYER1] - situaData.board.holes[STORE_PLAYER2];
	}
	else
	{
		for (int i = 0; i <= STORE_PLAYER1; ++i)
		{
			minimaxValue += situaData.board.holes[i];
			minimaxValue -= situaData.board.holes[i + (MAX_HOLE_COUNT / 2)];
		}
	}
	
	return minimaxValue;
}

bool MancalaAlgorithm::IsMax(const MancalaGameData &situaData)
{
	return situaData.isPlayer1Turn;
}

int MancalaAlgorithm::GetInfinityValue()
{
	return 10000;
}


MancalaBoardState MancalaAlgorithm::GetMancalaBoardState(const MancalaBoard &board)
{
	int p1MovableSeed = 0;
	int p2MovableSeed = 0;
	
	for (int i = 0; i < STORE_PLAYER1; ++i)
	{
		p1MovableSeed += board.holes[i];
	}
	
	for (int i = STORE_PLAYER1 + 1; i < STORE_PLAYER2; ++i)
	{
		p2MovableSeed += board.holes[i];
	}
	
	if (p1MovableSeed != 0 && p2MovableSeed != 0)
	{
		return Unfinished_Mancala;
	}
	
	if (board.holes[STORE_PLAYER1] + p1MovableSeed > 
		board.holes[STORE_PLAYER2] + p2MovableSeed)
	{
		return P1Win_Mancala;
	}
	else if (board.holes[STORE_PLAYER1] + p1MovableSeed ==
			 board.holes[STORE_PLAYER2] + p2MovableSeed)
	{
		return Draw_Mancala;
	}
	else
	{
		return P2Win_Mancala;
	}
}

bool MancalaAlgorithm::IsGameOver(const MancalaGameData &gameData)
{
	return GetMancalaBoardState(gameData.board) != Unfinished_Mancala;
}

void MancalaAlgorithm::SetSearchModel(MAN_SEARCH_MODEL model)
{
	m_SearchModel = model;
	
	if (model == MAN_SER_RANDOM)
	{
		srand(time(NULL)); 
	}
}

void MancalaAlgorithm::PrintMancalaData(const MancalaGameData &gameData)
{
	//玩家2棋子
	printf("\n    ");
	
	for (int i = STORE_PLAYER2 - 1; i > STORE_PLAYER1; --i)
	{
		printf("| %2d ", gameData.board.holes[i]);
	}
	
	printf("|");
	
	//大槽棋子
	printf("\n %2d |", gameData.board.holes[STORE_PLAYER2]);
	printf("                             ");
	printf("| %2d ", gameData.board.holes[STORE_PLAYER1]);
	
	//玩家1棋子
	printf("\n    ");
	
	for (int i = 0; i < STORE_PLAYER1; ++i)
	{
		printf("| %2d ", gameData.board.holes[i]);
	}
	
	printf("|");
	
	//输出当前玩家
	if (gameData.isPlayer1Turn)
	{
		printf("     CurPlayer = Player1\n");
	}
	else
	{
		printf("     CurPlayer = Player2\n");
	}

}
