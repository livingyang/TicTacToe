#import <Foundation/Foundation.h>

char
return_char (const unsigned int *board,
			 const unsigned int entry)
{
	return (board[entry] == 2) ? 'X' : (board[entry] == 1) ? 'O' : ' ';
}

void
print_board(const unsigned int *board)
{
	printf ("\n  %c | %c | %c \n ___|___|___\n"
			"  %c | %c | %c\n ___|___|___\n  %c | %c | %c\n    |   |\n\n",
			return_char (board, 1), return_char (board, 2),
			return_char (board, 3), return_char (board, 4),
			return_char (board, 5), return_char (board, 6),
			return_char (board, 7), return_char (board, 8),
			return_char (board, 9));
}


#import "TicTacToeDef.h"
void print_tictactoe_board(TicTacToeGameData &gameData)
{
	unsigned int board[10];
	
	for (int i = 0; i < 9; ++i)
	{
		board[i + 1] = gameData.board.pieces[i];
	}
	
	print_board(board);
}

#import "MinimaxAlgorithm.h"
#import "TicTacToeAlgorithm.h"
extern int LoopCount;

void testMinimaxAlgorithm()
{
	//测试用类包装的人工智能算法
	TicTacToeAlgorithm method;
	
	TicTacToeGameData gameData;
	makeInitTicTacToeData(gameData);
	while (method.IsGameOver(gameData) == false)
	{
		int bestMove;
		
		LoopCount = 0;
		method.GetBestMove(gameData, 5, bestMove);
		NSLog(@"LoopCount = %d", LoopCount);
		
		LoopCount = 0;
		method.GetBestMoveWithAlphaBeta(gameData, 5, bestMove);
		NSLog(@"LoopCount ab = %d", LoopCount);
		
		MoveTicTacToe(gameData, bestMove);
		
		print_tictactoe_board(gameData);
	}
}

#import "MancalaAlgorithm.h"
void testMancala()
{
	//初始化随机种子
	MancalaAlgorithm alg;
	alg.SetSearchModel(MancalaAlgorithm::MAN_SER_RANDOM);
	
	MancalaGameData gameData;
	makeInitMancalaData(gameData);
	alg.PrintMancalaData(gameData);
	
	while (alg.IsGameOver(gameData) == false)
	{
		int bestMove;
		
		LoopCount = 0;
		alg.GetBestMove(gameData, 2, bestMove);
		NSLog(@"LoopCount = %d", LoopCount);
		
		gameData = alg.CreateSituation(gameData, bestMove);
		
		alg.PrintMancalaData(gameData);
	}
	
	switch (alg.GetMancalaBoardState(gameData.board))
	{
		case P1Win_Mancala:
		{
			NSLog(@"P1 Win!!!");
		}break;
		case P2Win_Mancala:
		{
			NSLog(@"P2 Win!!!");
		}break;
		case Draw_Mancala:
		{
			NSLog(@"Draw!!!");
		}break;
		default:
		{
			NSLog(@"Imposible!!!");
		}break;
	}
}

#include "DotsAlgorithm.h"
void testDotsAlgorithm()
{
	DotsAlgorithm alg;
	
	DotsGameData gameData;
	std::list<DotsLine> moveGen;
	
	makeInitDotsData(gameData, 8, 7);
	
	alg.PrintDotsGameData(gameData);
	
	while (alg.IsGameOver(gameData) == false)
	{
		DotsLine bestMove;
		
		LoopCount = 0;
		alg.GetBestMove(gameData, 2, bestMove);
		NSLog(@"LoopCount = %d", LoopCount);
		
		gameData = alg.CreateSituation(gameData, bestMove);
		
		alg.PrintDotsGameData(gameData);
	}
}

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    // insert code here...
	//testMinimaxAlgorithm();
	//testMancala();
	testDotsAlgorithm();
	
    NSLog(@"Hello, World!");
    [pool drain];
    return 0;
}
