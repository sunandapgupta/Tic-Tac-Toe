class GameLogic {
  static String checkWinner(List<String> b) {
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

  static bool isDraw(List<String> b) => !b.contains("");
}