/*
 *  MinimaxAlgorithm.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-14.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef MINIMAXALGORITHM_H
#define MINIMAXALGORITHM_H

static int LoopCount = 0;

#include <list>

template<
typename SituationData, 
typename MoveData, 
typename MinimaxValueType
>
class MinimaxAlgorithm
{
public:
	MinimaxAlgorithm() {};
	
	virtual ~MinimaxAlgorithm() {};
	
	MinimaxValueType alphabeta(const SituationData &situation, int depth, MinimaxValueType &alpha, MinimaxValueType &beta)
	{
		//有待完善
		++LoopCount;
		
		if (depth == 0)
		{
			return GetSituationMinimaxValue(situation, depth);
		}
		
		std::list<MoveData> moveList;
		GenerateMove(situation, moveList);
		
		typename std::list<MoveData>::iterator iter = moveList.begin();
		MinimaxValueType minimaxValue = alphabeta(CreateSituation(situation, *iter), depth - 1, alpha, beta);
		
		if (IsMax(situation))
		{
			for (++iter; 
				 iter != moveList.end();
				 ++iter)
			{
				SituationData tempData = CreateSituation(situation, *iter);
				int tempValue = alphabeta(tempData, depth - 1, alpha, beta);
				
				minimaxValue = std::max(minimaxValue, tempValue);
				
				if (minimaxValue >= beta) 
				{
					return minimaxValue;
				}
			}
			
			alpha = minimaxValue;
			return minimaxValue;
		}
		else
		{
			for (++iter; 
				 iter != moveList.end();
				 ++iter)
			{
				SituationData tempData = CreateSituation(situation, *iter);
				int tempValue = alphabeta(tempData, depth - 1, alpha, beta);
				
				minimaxValue = std::min(minimaxValue, tempValue);
				
				if (minimaxValue <= alpha) 
				{
					return minimaxValue;
				}
			}
			
			beta = minimaxValue;
			return minimaxValue;
		}
	}
	
	bool GetBestMoveWithAlphaBeta(const SituationData &situation, int depth, MoveData &bestMove)
	{
		std::list<MoveData> moveList;
		GenerateMove(situation, moveList);
		
		if (moveList.size() == 0)
		{
			return false;
		}
		
		int alpha = -GetInfinityValue();
		int beta = GetInfinityValue();
		
		typename std::list<MoveData>::iterator iter = moveList.begin();
		MinimaxValueType minimaxValue = alphabeta(CreateSituation(situation, *iter), depth - 1, alpha, beta);
		bestMove = *iter;
		
		for (++iter; 
			 iter != moveList.end();
			 ++iter)
		{
			int alpha = -GetInfinityValue();
			int beta = GetInfinityValue();
			
			int tempValue = alphabeta(CreateSituation(situation, *iter), depth - 1, alpha, beta);
			
			if ((IsMax(situation) == true && tempValue > minimaxValue) ||
				(IsMax(situation) == false && tempValue < minimaxValue))
			{
				minimaxValue = tempValue;
				bestMove = *iter;
			}
		}
		
		return true;
	}
	
	MinimaxValueType CalculMinimaxValue(const SituationData &situation, int depth)
	{
		++LoopCount;
		
		if (depth == 0)
		{
			return GetSituationMinimaxValue(situation, depth);
		}
		
		std::list<MoveData> moveList;
		GenerateMove(situation, moveList);
		
		if (moveList.size() == 0)
		{
			return GetSituationMinimaxValue(situation, depth);
		}
		
		typename std::list<MoveData>::iterator iter = moveList.begin();
		MinimaxValueType minimaxValue = CalculMinimaxValue(CreateSituation(situation, *iter), depth - 1);
		
		for (++iter; 
			 iter != moveList.end();
			 ++iter)
		{
			int tempValue = CalculMinimaxValue(CreateSituation(situation, *iter), depth - 1);
			
			if (IsMax(situation))
			{
				minimaxValue = std::max(minimaxValue, tempValue);
			}
			else
			{
				minimaxValue = std::min(minimaxValue, tempValue);
			}
			
		}
		
		return minimaxValue;
	}
	
	bool GetBestMove(const SituationData &situation, int depth, MoveData &bestMove)
	{		
		std::list<MoveData> moveList;
		GenerateMove(situation, moveList);
		
		if (moveList.size() == 0)
		{
			return false;
		}
		
		typename std::list<MoveData>::iterator iter = moveList.begin();
		MinimaxValueType minimaxValue = CalculMinimaxValue(CreateSituation(situation, *iter), depth - 1);
		bestMove = *iter;
		
		for (++iter; 
			 iter != moveList.end();
			 ++iter)
		{
			int tempValue = CalculMinimaxValue(CreateSituation(situation, *iter), depth - 1);
			
			if ((IsMax(situation) == true && tempValue > minimaxValue) ||
				(IsMax(situation) == false && tempValue < minimaxValue))
			{
				minimaxValue = tempValue;
				bestMove = *iter;
			}
		}
		
		return true;
	}
	
	//接口，需要自己继承
	virtual void GenerateMove(const SituationData &situaData, std::list<MoveData> &moveList) = 0;
	
	virtual SituationData CreateSituation(const SituationData &situaData, const MoveData &moveData) = 0;
	
	virtual MinimaxValueType GetSituationMinimaxValue(const SituationData &situaData, int depth) = 0;
	
	virtual bool IsMax(const SituationData &situaData) = 0;
	
	virtual MinimaxValueType GetInfinityValue() = 0;
};

#endif //MINIMAXALGORITHM_H