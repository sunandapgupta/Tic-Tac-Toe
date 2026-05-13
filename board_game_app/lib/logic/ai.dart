import 'dart:math';

class AI {
  static String difficulty = "medium";

  static int getMove(List<String> b, String ai) {
    if (difficulty == "easy") {
      return _randomMove(b);
    }

    if (difficulty == "medium") {
      return Random().nextBool() ? _bestMove(b, ai) : _randomMove(b);
    }

    // hard but not perfect (winnable)
    if (Random().nextInt(10) < 3) {
      return _randomMove(b);
    }

    return _bestMove(b, ai);
  }

  static int _randomMove(List<String> b) {
    List<int> empty = [];
    for (int i = 0; i < 9; i++) {
      if (b[i] == "") empty.add(i);
    }
    return empty[Random().nextInt(empty.length)];
  }

  static int _bestMove(List<String> b, String ai) {
    int bestScore = -9999;
    int move = 0;

    for (int i = 0; i < 9; i++) {
      if (b[i] == "") {
        b[i] = ai;
        int score = _minimax(b, 0, false, ai);
        b[i] = "";

        if (score > bestScore) {
          bestScore = score;
          move = i;
        }
      }
    }

    return move;
  }

  static int _minimax(List<String> b, int depth, bool isMax, String ai) {
    String human = ai == "O" ? "X" : "O";

    String winner = _check(b);
    if (winner == ai) return 10 - depth;
    if (winner == human) return depth - 10;
    if (!b.contains("")) return 0;

    if (isMax) {
      int best = -9999;
      for (int i = 0; i < 9; i++) {
        if (b[i] == "") {
          b[i] = ai;
          best = max(best, _minimax(b, depth + 1, false, ai));
          b[i] = "";
        }
      }
      return best;
    } else {
      int best = 9999;
      for (int i = 0; i < 9; i++) {
        if (b[i] == "") {
          b[i] = human;
          best = min(best, _minimax(b, depth + 1, true, ai));
          b[i] = "";
        }
      }
      return best;
    }
  }

  static String _check(List<String> b) {
    List<List<int>> w = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var c in w) {
      if (b[c[0]] != "" &&
          b[c[0]] == b[c[1]] &&
          b[c[1]] == b[c[2]]) {
        return b[c[0]];
      }
    }

    return "";
  }
}