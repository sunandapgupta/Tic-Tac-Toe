import 'package:flutter/material.dart';
import 'dart:async';
import 'logic/game_logic.dart';
import 'logic/ai.dart';

class GameScreen extends StatefulWidget {
  final String mode;
  final String p1;
  final String p2;
  final String difficulty;
  final bool aiFirst;

  const GameScreen({
    super.key,
    required this.mode,
    required this.p1,
    required this.p2,
    required this.difficulty,
    required this.aiFirst,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  List<int> winLine = [];

  bool xTurn = true;
  bool over = false;
  bool aiThinking = false;

  int p1Wins = 0;
  int p2Wins = 0;
  int draws = 0;
  int gameCount = 0;

  bool showWinnerScreen = false;
  String winnerText = "";

  // AI ONLY
  String playerSymbol = "X";
  String aiSymbol = "O";

  @override
  void initState() {
    super.initState();

    if (widget.mode == "AI") {
      if (widget.aiFirst) {
        playerSymbol = "O";
        aiSymbol = "X";
        xTurn = false;
        Future.delayed(const Duration(milliseconds: 400), aiMove);
      } else {
        playerSymbol = "X";
        aiSymbol = "O";
      }
    }
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, "");
      winLine = [];
      over = false;
      xTurn = true;
      showWinnerScreen = false;
    });

    if (widget.mode == "AI" && widget.aiFirst) {
      xTurn = false;
      Future.delayed(const Duration(milliseconds: 300), aiMove);
    }
  }

  void showFinalResult() {
    String winner;

    if (p1Wins > p2Wins) {
      winner = widget.p1;
    } else if (p2Wins > p1Wins) {
      winner = widget.mode == "AI" ? "AI" : widget.p2;
    } else {
      winner = "DRAW";
    }

    setState(() {
      showWinnerScreen = true;
      winnerText = "🎉 HURRAY!\n$winner WINS THE MATCH!";
    });
  }

  void checkMatch() {
    gameCount++;
    if (gameCount >= 5) {
      showFinalResult();
    }
  }

  void aiMove() {
    if (over) return;

    setState(() => aiThinking = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      int move = AI.getMove(board, aiSymbol);

      setState(() {
        aiThinking = false;
        board[move] = aiSymbol;

        String w = GameLogic.checkWinner(board);
        winLine = GameLogic.getWinningLine(board);

        if (w != "") {
          over = true;
          p2Wins++;
          checkMatch();
        } else if (GameLogic.isDraw(board)) {
          over = true;
          draws++;
          checkMatch();
        } else {
          xTurn = true;
        }
      });
    });
  }

  void tap(int i) {
    if (board[i] != "" || over) return;

    // PvP strict rule fix
    if (widget.mode == "AI" && !xTurn) return;

    String symbol;

    if (widget.mode == "AI") {
      symbol = playerSymbol;
    } else {
      symbol = xTurn ? "X" : "O";
    }

    setState(() {
      board[i] = symbol;

      String w = GameLogic.checkWinner(board);
      winLine = GameLogic.getWinningLine(board);

      if (w != "") {
        over = true;

        if (widget.mode == "AI") {
          if (w == playerSymbol) p1Wins++;
          if (w == aiSymbol) p2Wins++;
        } else {
          if (w == "X") p1Wins++;
          if (w == "O") p2Wins++;
        }

        checkMatch();
      } else if (GameLogic.isDraw(board)) {
        over = true;
        draws++;
        checkMatch();
      } else {
        xTurn = !xTurn;
      }
    });

    if (widget.mode == "AI" && !over && !xTurn) {
      aiMove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Game ${gameCount + 1}/5",
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Stack(
        children: [

          Column(
            children: [
              const SizedBox(height: 10),

              Text(
                widget.mode == "AI"
                    ? "${widget.p1} ($playerSymbol) vs AI ($aiSymbol)"
                    : "${widget.p1} (X) vs ${widget.p2} (O)",
                style: const TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 10),

              Text(
                "${widget.p1}: $p1Wins  |  ${widget.mode == "AI" ? "AI" : widget.p2}: $p2Wins",
                style: const TextStyle(color: Colors.white70),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: 9,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onTap: () => tap(i),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: winLine.contains(i)
                              ? Colors.greenAccent
                              : const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            board[i],
                            style: TextStyle(
                              fontSize: 40,
                              color: board[i] == "X"
                                  ? Colors.blue
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: resetBoard,
                child: const Text("Next Round"),
              ),
            ],
          ),

          if (showWinnerScreen)
            Container(
              color: Colors.black.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("🎉🎉🎉", style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 20),
                    Text(
                      winnerText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Home"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}