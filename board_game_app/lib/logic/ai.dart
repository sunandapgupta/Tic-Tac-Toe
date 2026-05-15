import 'dart:math';

class AI {
  static String difficulty = "medium";

  static int getMove(List<String> b, String ai) {
    // EASY
    if (difficulty == "easy") {
      if (Random().nextInt(100) < 70) {
        return _randomMove(b);
      }
      return _bestMove(b, ai);
    }

    // MEDIUM
    if (difficulty == "medium") {
      if (Random().nextInt(100) < 40) {
        return _randomMove(b);
      }
      return _smartMove(b, ai);
    }

    // HARD
    // Smart but still beatable sometimes
    if (difficulty == "hard") {
      if (Random().nextInt(100) < 15) {
        return _smartMove(b, ai);
      }
      return _bestMove(b, ai);
    }

    // IMPOSSIBLE
    // Perfect AI — never loses
    if (difficulty == "expert") {
      return _bestMove(b, ai);
    }

    return _randomMove(b);
  }

  static int _randomMove(List<String> b) {
    List<int> empty = [];

    for (int i = 0; i < 9; i++) {
      if (b[i] == "") {
        empty.add(i);
      }
    }

    return empty[Random().nextInt(empty.length)];
  }

  // SMART HUMAN-LIKE MOVE
  static int _smartMove(List<String> b, String ai) {
    String human = ai == "O" ? "X" : "O";

    // WIN IF POSSIBLE
    for (int i = 0; i < 9; i++) {
      if (b[i] == "") {
        b[i] = ai;

        if (_check(b) == ai) {
          b[i] = "";
          return i;
        }

        b[i] = "";
      }
    }

    // BLOCK PLAYER
    for (int i = 0; i < 9; i++) {
      if (b[i] == "") {
        b[i] = human;

        if (_check(b) == human) {
          b[i] = "";
          return i;
        }

        b[i] = "";
      }
    }

    // TAKE CENTER
    if (b[4] == "") {
      return 4;
    }

    // TAKE CORNERS
    List<int> corners = [0, 2, 6, 8];
    corners.shuffle();

    for (int c in corners) {
      if (b[c] == "") {
        return c;
      }
    }

    return _randomMove(b);
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

    if (winner == ai) {
      return 10 - depth;
    }

    if (winner == human) {
      return depth - 10;
    }

    if (!b.contains("")) {
      return 0;
    }

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
      if (b[c[0]] != "" && b[c[0]] == b[c[1]] && b[c[1]] == b[c[2]]) {
        return b[c[0]];
      }
    }

    return "";
  }
}
