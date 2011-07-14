/*
 *  TicTacToeAlgorithm.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-14.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef TICTACTOEALGORITHM_H
#define TICTACTOEALGORITHM_H

#include "TicTacToeDef.h"
#include "MinimaxAlgorithm.h"

class TicTacToeAlgorithm : public MinimaxAlgorithm<TicTacToeGameData, int, int>
{
public:
	TicTacToeAlgorithm() { srand(time(NULL)); }
	~TicTacToeAlgorithm() {}
	
	void GenerateMove(const TicTacToeGameData &situaData, std::list<int> &moveList);
	
	TicTacToeGameData CreateSituation(const TicTacToeGameData &situaData, const int &moveData);
	
	TicTacToeBoardState GetTicTacToeBoardState(const TicTacToeBoard &board);
	
	bool IsGameOver(const TicTacToeGameData &gameData);
	
	int GetSituationMinimaxValue(const TicTacToeGameData &situaData, int depth);
	
private:
	bool IsMax(const TicTacToeGameData &situaData);
	
	int GetPieceMinimaxValue(tttPiece piece);
	
	int GetInfinityValue();
};

#endif //TICTACTOEALGORITHM_H