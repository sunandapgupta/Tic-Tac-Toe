class Player {
  String name;
  int wins;
  int losses;

  Player({
    required this.name,
    this.wins = 0,
    this.losses = 0,
  });

  void addWin() => wins++;
  void addLoss() => losses++;
}