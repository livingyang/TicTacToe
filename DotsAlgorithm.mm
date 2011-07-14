/*
 *  DotsAlgorithm.cpp
 *  TicTacToe
 *
 *  Created by lee living on 11-3-17.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#include "DotsAlgorithm.h"
#include <map>
#include <vector>
#include <algorithm>

class DotsLineEquiper
{
public:
	DotsLineEquiper(const DotsLine &line) : m_Line(line) {};
	
	bool operator() (const DotsTurnMove &turnMove)
	{
		return ((turnMove.line.points[0] == m_Line.points[0]) && 
				(turnMove.line.points[1] == m_Line.points[1]));
	}
	
private:
	DotsLine m_Line;
};

void DotsAlgorithm::GenerateMove(const DotsGameData &situaData, std::list<DotsLine> &moveList)
{
	moveList.clear();
	
	if (IsGameOver(situaData))
	{
		return;
	}
	
	if (situaData.maxRow * situaData.maxColumn > 60000)
	{
		printf("DotsAlgorithm::GenerateMove Dots data two big");
	}
	
	std::vector<DotsLine> lineVector;
	
	//生成所有的线条组合
	for (int row = 0; row < situaData.maxRow; ++row)
	{
		for (int col = 0; col < situaData.maxColumn; ++col)
		{
			DotsPoint point = row * situaData.maxColumn + col;
			
			if (col != situaData.maxColumn - 1)
			{
				DotsPoint rightPoint = point + 1;
				DotsLine line = {point, rightPoint};
				lineVector.push_back(line);
			}
			
			if (row != situaData.maxRow - 1)
			{
				DotsPoint bottomPoint = point + situaData.maxColumn;
				DotsLine line = {point, bottomPoint};
				lineVector.push_back(line);
			}
		}
	}
	
	srand(time(NULL));
	std::random_shuffle(lineVector.begin(), lineVector.end());
	
	for (std::vector<DotsLine>::iterator iter = lineVector.begin(); 
		 iter != lineVector.end(); 
		 ++iter) 
	{
		if (std::find_if(situaData.dotsLineList.begin(), 
						 situaData.dotsLineList.end(),
						 DotsLineEquiper(*iter)) == situaData.dotsLineList.end())
		{
			moveList.push_back(*iter);
		}
	}
}

DotsGameData DotsAlgorithm::CreateSituation(const DotsGameData &situaData, const DotsLine &moveData)
{
	//判断非法移动数据
	int p0Row = moveData.points[0] / situaData.maxColumn;
	int p0Col = moveData.points[0] % situaData.maxColumn;
	
	int p1Row = moveData.points[1] / situaData.maxColumn;
	int p1Col = moveData.points[1] % situaData.maxColumn;
	
	if (!(p0Row == p1Row && p0Col + 1 == p1Col) &&
		!(p0Col == p1Col && p0Row + 1 == p1Row)) 
	{
		return situaData;
	}
	
	for (std::list<DotsTurnMove>::const_iterator iter = situaData.dotsLineList.begin(); 
		 iter != situaData.dotsLineList.end();
		 ++iter)
	{
		if (memcmp(&((*iter).line), &moveData, sizeof(moveData)) == 0)
		{
			return situaData;
		}
	}
	
	//先创建移动数据
	DotsGameData movedData = situaData;
	DotsTurnMove turnMove = {moveData, situaData.isPlayer1Turn};
	movedData.dotsLineList.push_back(turnMove);
	
	//判断是否形成格子，若是，则不切换玩家，若否，则切换玩家
	if (p0Row == p1Row && p0Col + 1 == p1Col)
	{
		//这是一条横线
		if (p0Row > 0) 
		{
			//有一个上方的格子需要检测
			DotsSquare square =
			{
				moveData.points[0] - situaData.maxColumn, 
				moveData.points[1] - situaData.maxColumn,
				moveData.points[0],
				moveData.points[1],
			};
			
			if (IsDotsDataContainedSquare(movedData, square))
			{
				return movedData;
			}
		}
		
		if (p0Row < movedData.maxRow - 1)
		{
			//有一个下方的格子需要检测
			DotsSquare square =
			{
				moveData.points[0],
				moveData.points[1],
				moveData.points[0] + situaData.maxColumn, 
				moveData.points[1] + situaData.maxColumn,
			};
			
			if (IsDotsDataContainedSquare(movedData, square))
			{
				return movedData;
			}
		}
	}
	else if (p0Col == p1Col && p0Row + 1 == p1Row)
	{
		//这是一条纵线
		if (p0Col > 0) 
		{
			//有一个左方的格子需要检测
			DotsSquare square =
			{
				moveData.points[0] - 1, 
				moveData.points[0],
				moveData.points[1] - 1,
				moveData.points[1],
			};
			
			if (IsDotsDataContainedSquare(movedData, square))
			{
				return movedData;
			}
		}
		
		if (p0Col < movedData.maxColumn - 1)
		{
			//有一个右方的格子需要检测
			DotsSquare square =
			{
				moveData.points[0], 
				moveData.points[0] + 1,
				moveData.points[1],
				moveData.points[1] + 1,
			};
			
			if (IsDotsDataContainedSquare(movedData, square))
			{
				return movedData;
			}
		}
	}
	else
	{
		//错误情况
		printf("DotsAlgorithm::CreateSituation 数据有误");
		return movedData;
	}

	//到这里说明没有格子生成
	movedData.isPlayer1Turn = !movedData.isPlayer1Turn;
	return movedData;
}

typedef	std::map<int/*Square index*/, int/*Line count*/> SquareLineCountMap;
class SquareEdgeCounter
{
public:
	SquareEdgeCounter(int maxRow, int maxCol) : 
	m_MaxRow(maxRow),
	m_MaxColumn(maxCol)
	{}
	
	int operator() (SquareLineCountMap &lineCountMap, int row, int col, AreaInfoMap &areaInfo, bool isPlayer1Move)
	{
		int squareIndex = row * m_MaxColumn + col;
		
		if (lineCountMap.find(squareIndex) == lineCountMap.end())
		{
			lineCountMap[squareIndex] = 1;
		}
		else
		{
			lineCountMap[squareIndex] += 1;
			
			if (lineCountMap[squareIndex] == 4)
			{
				areaInfo[squareIndex] = isPlayer1Move;
			}
		}
		
		return lineCountMap[squareIndex];
	}
	
private:
	int m_MaxRow;
	int m_MaxColumn;
};

int DotsAlgorithm::GetSituationMinimaxValue(const DotsGameData &situaData, int depth)
{
	AreaInfoMap areaInfo;
	GenerateAreaInfo(situaData, areaInfo);
	
	int p1AreaCount = 0;
	int p2AreaCount = 0;
	for (AreaInfoMap::iterator iter = areaInfo.begin(); 
		 iter != areaInfo.end();
		 ++iter)
	{
		if ((*iter).second == true)
		{
			++p1AreaCount;
		}
		else
		{
			++p2AreaCount;
		}
	}
	
	return p1AreaCount - p2AreaCount;
}

bool DotsAlgorithm::IsMax(const DotsGameData &situaData)
{
	return situaData.isPlayer1Turn;
}

int DotsAlgorithm::GetInfinityValue()
{
	return 60000;
}

bool DotsAlgorithm::IsGameOver(const DotsGameData &gameData)
{
	int totalLine = 2 * gameData.maxRow * gameData.maxColumn - 
	(gameData.maxRow + gameData.maxColumn);
	
	return gameData.dotsLineList.size() == totalLine;
}

void DotsAlgorithm::GenerateAreaInfo(const DotsGameData &gameData, AreaInfoMap &areaInfo)
{
	areaInfo.clear();
	SquareLineCountMap lineCountMap;
	SquareEdgeCounter edgeCounter(gameData.maxRow - 1, gameData.maxColumn - 1);
	
	for (std::list<DotsTurnMove>::const_iterator iter = gameData.dotsLineList.begin(); 
		 iter != gameData.dotsLineList.end();
		 ++iter)
	{
		DotsLine line = (*iter).line;
		
		int p0Row = line.points[0] / gameData.maxColumn;
		int p0Col = line.points[0] % gameData.maxColumn;
		
		int p1Row = line.points[1] / gameData.maxColumn;
		int p1Col = line.points[1] % gameData.maxColumn;
		
		if (p0Row == p1Row && p0Col + 1 == p1Col)
		{
			//上边是此横线的格子加1
			if (p0Row != gameData.maxRow - 1)
			{
				edgeCounter(lineCountMap, p0Row, p0Col, areaInfo, (*iter).isPlayer1Move);
			}
			
			//下边是此横线的格子加1
			if (p0Row != 0)
			{
				edgeCounter(lineCountMap, p0Row - 1, p0Col, areaInfo, (*iter).isPlayer1Move);
			}
		}
		else 
		{	
			//左边是此纵线的格子加1
			if (p0Col != gameData.maxColumn - 1)
			{
				edgeCounter(lineCountMap, p0Row, p0Col, areaInfo, (*iter).isPlayer1Move);
			}
			
			//右边是此纵线的格子加1
			if (p0Col != 0)
			{
				edgeCounter(lineCountMap, p0Row, p0Col - 1, areaInfo, (*iter).isPlayer1Move);
			}
		}
	}
}

/*
 *---*---*
 | 1 | 2 |
 *---*---*
 | 2 | 2 |
 *---*---*
 */

void DotsAlgorithm::PrintDotsGameData(const DotsGameData &gameData)
{
	AreaInfoMap areaInfo;
	GenerateAreaInfo(gameData, areaInfo);
	
	int p1AreaCount = 0;
	int p2AreaCount = 0;
	for (AreaInfoMap::iterator iter = areaInfo.begin(); 
		 iter != areaInfo.end();
		 ++iter)
	{
		if ((*iter).second == true)
		{
			++p1AreaCount;
		}
		else
		{
			++p2AreaCount;
		}
	}
	
	printf("P1 square = %d,\n P2 square = %d\n", p1AreaCount, p2AreaCount);
	
	//首先建立关于线段的集合
	for (int row = 0; row < gameData.maxRow; ++row)
	{
		//打印横线
		for (int col = 0; col < gameData.maxColumn; ++col)
		{
			DotsPoint point = row * gameData.maxColumn + col;
			printf("*");
			
			DotsLine line = {point, point + 1};
			
			if (std::find_if(gameData.dotsLineList.begin(), 
							 gameData.dotsLineList.end(),
							 DotsLineEquiper(line)) != gameData.dotsLineList.end())
			{
				printf("---");
			}
			else
			{
				printf("   ");
			}
		}
		
		printf("\n");
		
		//打印纵线和格子所属
		for (int col = 0; col < gameData.maxColumn; ++col)
		{
			DotsPoint point = row * gameData.maxColumn + col;
			DotsLine line = {point, point + gameData.maxColumn};
			
			if (std::find_if(gameData.dotsLineList.begin(), 
							 gameData.dotsLineList.end(),
							 DotsLineEquiper(line)) != gameData.dotsLineList.end())
			{
				printf("|");
			}
			else
			{
				printf(" ");
			}
			
			printf("   ");
		}
		
		printf("\n");
	}
}
