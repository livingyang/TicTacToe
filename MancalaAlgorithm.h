/*
 *  MancalaAlgorithm.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-15.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef MANCALAALGORITHM_H
#define MANCALAALGORITHM_H

#include "MancalaDef.h"
#include "MinimaxAlgorithm.h"

class MancalaAlgorithm : public MinimaxAlgorithm<MancalaGameData, int, int>
{
public:
	//非洲棋的寻找优先顺序
	enum MAN_SEARCH_MODEL 
	{
		MAN_SER_NORMAL,		//普通，按序号优先
		MAN_SER_RANDOM,		//随机选择优先顺序
	};
	
public:
	MancalaAlgorithm() : m_SearchModel(MAN_SER_NORMAL) {};
	~MancalaAlgorithm() {};
	
	virtual void GenerateMove(const MancalaGameData &situaData, std::list<int> &moveList);
	
	virtual MancalaGameData CreateSituation(const MancalaGameData &situaData, const int &moveData);
	
	virtual int GetSituationMinimaxValue(const MancalaGameData &situaData, int depth);
	
	virtual bool IsMax(const MancalaGameData &situaData);
	
	virtual int GetInfinityValue();
	
	MancalaBoardState GetMancalaBoardState(const MancalaBoard &board);
	
	bool IsGameOver(const MancalaGameData &gameData);
	
	void PrintMancalaData(const MancalaGameData &gameData);
	
	void SetSearchModel(MAN_SEARCH_MODEL model);
	
private:
	MAN_SEARCH_MODEL m_SearchModel;
};


#endif //MANCALAALGORITHM_H