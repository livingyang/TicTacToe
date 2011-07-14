/*
 *  TicTacToeDef.h
 *  TicTacToe
 *
 *  Created by lee living on 11-3-11.
 *  Copyright 2011 LieHuo Tech. All rights reserved.
 *
 */

#ifndef TICTACTOEDEF_H
#define TICTACTOEDEF_H

enum TicTacToe_Piece_Type
{
	None_Piece = 0,
	Piece1,
	Piece2,
};

typedef char tttPiece;

enum TicTacToe_Board_State 
{
	P1Win,
	P2Win,
	Draw,
	Unfinished,
};
typedef short TicTacToeBoardState;

typedef struct
{
	tttPiece pieces[9];
}TicTacToeBoard;

/*!
	@名    称：TicTacToeGameData
	@描    述：井子棋游戏的数据
	@备    注：此数据可用于保存，读取，和人工智能分析
*/
typedef struct
{
	TicTacToeBoard board;
	
	bool isPlayer1Turn;
}TicTacToeGameData;

/*!
	@名    称：makeInitTicTacToeData
	@描    述：获取初始化的井子棋数据
	@备    注：
*/
static inline
void makeInitTicTacToeData(TicTacToeGameData &gameData)
{
	gameData.isPlayer1Turn = true;
	
	memset(&gameData.board, 0, sizeof(gameData.board));
}

const short CheckPieceGroup[] = 
{
	0, 1, 2,
	3, 4, 5,
	6, 7, 8,
	0, 3, 6,
	1, 4, 7,
	2, 5, 8,
	0, 4, 8,
	6, 4, 2,
};

const int CheckCount = (sizeof(CheckPieceGroup) / sizeof(CheckPieceGroup[0]));

static inline
bool MoveTicTacToe(TicTacToeGameData &gameData, int movePosition)
{
	if (movePosition < 0 || movePosition >= 9)
	{
		return false;
	}
	
	if (gameData.board.pieces[movePosition] != None_Piece)
	{
		return false;
	}
	
	if (gameData.isPlayer1Turn)
	{
		gameData.board.pieces[movePosition] = Piece1;
	}
	else
	{
		gameData.board.pieces[movePosition] = Piece2;
	}
	
	gameData.isPlayer1Turn = !gameData.isPlayer1Turn;
	
	return true;
}

#endif //TICTACTOEDEF_H