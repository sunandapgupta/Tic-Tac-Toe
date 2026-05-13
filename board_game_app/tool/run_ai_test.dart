import 'package:board_game_app/logic/ai.dart';

void main() {
  AI.difficulty = 'hard';
  final board = ['X', '', '', '', 'O', '', '', '', ''];
  final move = AI.getMove(board, 'O');
  print('AI move: $move');
}
