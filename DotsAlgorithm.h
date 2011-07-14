/*
 *  DotsAlgorithm.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-17.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef DOTSALGORITHM_H
#define DOTSALGORITHM_H

#include "DotsDef.h"
#include "MinimaxAlgorithm.h"

class DotsAlgorithm : public MinimaxAlgorithm<DotsGameData, DotsLine, int>
{
public:
	DotsAlgorithm() {};
	~DotsAlgorithm() {};
	
	virtual void GenerateMove(const DotsGameData &situaData, std::list<DotsLine> &moveList);
	
	virtual DotsGameData CreateSituation(const DotsGameData &situaData, const DotsLine &moveData);
	
	virtual int GetSituationMinimaxValue(const DotsGameData &situaData, int depth);
	
	virtual bool IsMax(const DotsGameData &situaData);
	
	virtual int GetInfinityValue();
	
	bool IsGameOver(const DotsGameData &gameData);
	
	void GenerateAreaInfo(const DotsGameData &gameData, AreaInfoMap &areaInfo);
	
	void PrintDotsGameData(const DotsGameData &gameData);
};


#endif //DOTSALGORITHM_H