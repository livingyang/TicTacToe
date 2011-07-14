/*
 *  TicTacToeAlgorithm.cpp
 *  TicTacToe
 *
 *  Created by lee living on 11-3-14.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#include "TicTacToeAlgorithm.h"
#include <algorithm>

void TicTacToeAlgorithm::GenerateMove(const TicTacToeGameData &situaData, std::list<int> &moveList)
{
	moveList.clear();
	
	if (IsGameOver(situaData))
	{
		return;
	}
	
	int searchPriority[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
	std::random_shuffle(searchPriority, searchPriority + 9);
	
	for (int i = 0; i < 9; ++i)
	{
		if (situaData.board.pieces[searchPriority[i]] == None_Piece)
		{
			moveList.push_back(searchPriority[i]);
		}
	}
}

TicTacToeGameData TicTacToeAlgorithm::CreateSituation(const TicTacToeGameData &situaData, const int &moveData)
{
	TicTacToeGameData movedData = situaData;
	MoveTicTacToe(movedData, moveData);
	
	return movedData;
}

TicTacToeBoardState TicTacToeAlgorithm::GetTicTacToeBoardState(const TicTacToeBoard &board)
{
	bool hasNonePiece = false;
	
	for (int i = 0; i < CheckCount; i += 3)
	{
		if (board.pieces[CheckPieceGroup[i]] == None_Piece ||
			board.pieces[CheckPieceGroup[i + 1]] == None_Piece ||
			board.pieces[CheckPieceGroup[i + 2]] == None_Piece) 
		{
			hasNonePiece = true;
			continue;
		}
		
		if (board.pieces[CheckPieceGroup[i]] == board.pieces[CheckPieceGroup[i + 1]] &&
			board.pieces[CheckPieceGroup[i]] == board.pieces[CheckPieceGroup[i + 2]])
		{
			if (board.pieces[CheckPieceGroup[i]] == Piece1)
			{
				return P1Win;
			}
			else
			{
				return P2Win;
			}
		}
	}
	
	if (hasNonePiece)
	{
		return Unfinished;
	}
	else
	{
		return Draw;
	}
}

bool TicTacToeAlgorithm::IsGameOver(const TicTacToeGameData &gameData)
{
	if (GetTicTacToeBoardState(gameData.board) == Unfinished)
	{
		return false;
	}
	
	return true;
}

int TicTacToeAlgorithm::GetSituationMinimaxValue(const TicTacToeGameData &situaData, int depth)
{
	int minimaxValue = 0;
	
	for (int i = 0; i < CheckCount; i += 3)
	{
		int groupValue = 0;
		groupValue += GetPieceMinimaxValue(situaData.board.pieces[CheckPieceGroup[i]]);
		groupValue += GetPieceMinimaxValue(situaData.board.pieces[CheckPieceGroup[i + 1]]);
		groupValue += GetPieceMinimaxValue(situaData.board.pieces[CheckPieceGroup[i + 2]]);
		
		if (groupValue == 3)
		{
			return 100 + depth;
		}
		else if (groupValue == -3)
		{
			return -100 - depth;
		}
		else
		{
			minimaxValue += groupValue;
		}
	}
	
	return minimaxValue;
}

bool TicTacToeAlgorithm::IsMax(const TicTacToeGameData &situaData)
{
	return situaData.isPlayer1Turn;
}

int TicTacToeAlgorithm::GetPieceMinimaxValue(tttPiece piece)
{
	int pieceValue[] = 
	{
		None_Piece, 0,
		Piece1, 1,
		Piece2, -1,
	};
	
	if (piece > Piece2 || piece < None_Piece) 
	{
		return 0;
	}
	
	return pieceValue[piece * 2 + 1]; 
}

int TicTacToeAlgorithm::GetInfinityValue()
{
	return 6000;
}
