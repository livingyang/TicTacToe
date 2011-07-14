/*
 *  MancalaDef.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-15.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef MANCALADEF_H
#define MANCALADEF_H

enum 
{
	STORE_PLAYER1 = 6,
	STORE_PLAYER2 = 13,
};

#define MAX_HOLE_COUNT (14)

typedef char MancalaHole;

typedef struct
{
	MancalaHole holes[MAX_HOLE_COUNT];
}MancalaBoard;

enum Mancala_Board_State 
{
	P1Win_Mancala,
	P2Win_Mancala,
	Draw_Mancala,
	Unfinished_Mancala,
};
typedef short MancalaBoardState;

typedef struct
{
	MancalaBoard board;
	
	bool isPlayer1Turn;
}MancalaGameData;

static inline
void makeInitMancalaData(MancalaGameData &gameData)
{
	gameData.isPlayer1Turn = true;
	
	memset(&gameData.board, 0, sizeof(gameData.board));
	
	for (int i = 0; i < MAX_HOLE_COUNT; ++i)
	{
		gameData.board.holes[i] = 4;
	}
	
	gameData.board.holes[STORE_PLAYER1] = 0;
	gameData.board.holes[STORE_PLAYER2] = 0;
}

#endif //MANCALADEF_H