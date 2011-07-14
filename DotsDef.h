/*
 *  DotsDef.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-17.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef DOTSDEF_H
#define DOTSDEF_H

#include <list>
#include <set>
#include <map>

//点格棋的坐标点
typedef unsigned short DotsPoint;

//每个点格棋的线段，由两个相邻的点组成
typedef struct
{
	DotsPoint points[2];
}DotsLine;

typedef struct
{
	//leftTop, rightTop, leftBottom, rightBottom
	DotsPoint points[4];
}DotsSquare;

typedef struct
{
	DotsLine line;
	
	bool isPlayer1Move;
}DotsTurnMove;

typedef struct
{
	std::list<DotsTurnMove> dotsLineList;
	
	unsigned short maxRow;
	
	unsigned short maxColumn;
	
	bool isPlayer1Turn;
}DotsGameData;

struct DotsLineComparer
{
	DotsLineComparer() {};
	
	bool operator() (const DotsLine &line1, const DotsLine &line2)
	{
		if (line1.points[0] < line2.points[0])
		{
			return true;
		}
		
		if (line1.points[1] < line2.points[1])
		{
			return true;
		}
		
		return false;
	}
};

typedef std::set<DotsLine, DotsLineComparer> DotsLineSet;

typedef std::map<int /*Area index*/, bool /*Area is player1 ?*/> AreaInfoMap;

static inline
void makeInitDotsData(DotsGameData &gameData, unsigned short maxRow, unsigned short maxColumn)
{
	if (maxRow * maxColumn > 60000)
	{
		printf("makeInitMancalaData Dots data two big");
	}
	
	gameData.dotsLineList.clear();
	
	gameData.maxRow = maxRow;
	gameData.maxColumn = maxColumn;
	
	gameData.isPlayer1Turn = true;
}

static inline
bool IsDotsDataContainedSquare(const DotsGameData &gameData, const DotsSquare &square)
{
	DotsLineSet lineSet;
	
	DotsLine line1 = {square.points[0], square.points[1]};
	DotsLine line2 = {square.points[0], square.points[2]};
	DotsLine line3 = {square.points[1], square.points[3]};
	DotsLine line4 = {square.points[2], square.points[3]};

	lineSet.insert(line1);
	lineSet.insert(line2);
	lineSet.insert(line3);
	lineSet.insert(line4);
	
	int lineCount = 0;
	for (std::list<DotsTurnMove>::const_iterator iter = gameData.dotsLineList.begin();
		 iter != gameData.dotsLineList.end(); 
		 ++iter)
	{
		if (lineSet.find((*iter).line) != lineSet.end())
		{
			++lineCount;
		}
	}
	
	return (lineCount == 4);
}

#endif //DOTSDEF_H