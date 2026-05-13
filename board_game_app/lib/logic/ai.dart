class AI {
  static int easyMove(List<String> b) {
    List<int> e = [];
    for (int i = 0; i < 9; i++) {
      if (b[i] == "") e.add(i);
    }
    e.shuffle();
    return e.first;
  }

  static int? findBestMove(List<String> b, String p) {
    int best = -9999;
    int move = -1;

    for (int i = 0; i < 9; i++) {
      if (b[i] == "") {
        b[i] = p;
        int score = _minimax(b, 0, false);
        b[i] = "";

        if (score > best) {
          best = score;
          move = i;
        }
      }
    }
    return move == -1 ? null : move;
  }

  static int _minimax(List<String> b, int d, bool isMax) {
    String r = _winner(b);

    if (r == "O") return 10 - d;
    if (r == "X") return d - 10;
    if (!b.contains("")) return 0;

    if (isMax) {
      int best = -9999;
      for (int i = 0; i < 9; i++) {
        if (b[i] == "") {
          b[i] = "O";
          best = _max(best, _minimax(b, d + 1, false));
          b[i] = "";
        }
      }
      return best;
    } else {
      int best = 9999;
      for (int i = 0; i < 9; i++) {
        if (b[i] == "") {
          b[i] = "X";
          best = _min(best, _minimax(b, d + 1, true));
          b[i] = "";
        }
      }
      return best;
    }
  }

  static int _max(int a, int b) => a > b ? a : b;
  static int _min(int a, int b) => a < b ? a : b;

  static String _winner(List<String> b) {
    List<List<int>> w = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];

    for (var c in w) {
      if (b[c[0]] != "" && b[c[0]] == b[c[1]] && b[c[1]] == b[c[2]]) {
        return b[c[0]];
      }
    }
    return "";
  }
}