import 'package:flutter/material.dart';
import 'logic/game_logic.dart';
import 'logic/ai.dart';

class GameScreen extends StatefulWidget {
  final String mode;
  final String p1;
  final String p2;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.mode,
    required this.p1,
    required this.p2,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, "");
  bool xTurn = true;
  bool over = false;

  int p1Wins = 0;
  int p2Wins = 0;
  int draws = 0;

  void reset() {
    setState(() {
      board = List.filled(9, "");
      xTurn = true;
      over = false;
    });
  }

  void result(String t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Game Over"),
        content: Text(t),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              reset();
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }

  void aiMove() {
    int move;

    if (widget.difficulty == "Easy") {
      move = AI.easyMove(board);
    } else {
      move = AI.findBestMove(board, "O") ?? AI.easyMove(board);
    }

    setState(() {
      board[move] = "O";

      String w = GameLogic.checkWinner(board);

      if (w != "") {
        over = true;
        p2Wins++;
        result("AI Wins!");
      } else if (GameLogic.isDraw(board)) {
        over = true;
        draws++;
        result("Draw!");
      } else {
        xTurn = true;
      }
    });
  }

  void tap(int i) {
    if (board[i] != "" || over) return;
    if (widget.mode == "AI" && !xTurn) return;

    setState(() {
      board[i] = xTurn ? "X" : "O";

      String w = GameLogic.checkWinner(board);

      if (w != "") {
        over = true;
        if (w == "X") p1Wins++;
        if (w == "O") p2Wins++;
        result("$w Wins!");
        return;
      }

      if (GameLogic.isDraw(board)) {
        over = true;
        draws++;
        result("Draw!");
        return;
      }

      xTurn = !xTurn;
    });

    if (widget.mode == "AI" && !over && !xTurn) {
      Future.delayed(const Duration(milliseconds: 300), aiMove);
    }
  }

  Color color(String v) {
    if (v == "X") return Colors.blue;
    if (v == "O") return Colors.red;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tic Tac Toe Pro")),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Text("${widget.p1} vs ${widget.mode == "AI" ? "AI" : widget.p2}"),

          Text("X: $p1Wins  |  O: $p2Wins  |  Draws: $draws"),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: () => tap(i),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Text(
                        board[i],
                        style: TextStyle(
                          fontSize: 40,
                          color: color(board[i]),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}