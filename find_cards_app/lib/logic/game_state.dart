import 'card.dart';

enum GameStatus { playing, noMoves, finished }

class GameState {
  factory GameState() => _inst;
  static final _inst = GameState._();
  GameState._();

  int moves = _startMoves;
  static const _startMoves = 20;
  List<Card> cards = [];
  Card? selectedCard;
  bool canSelect = true;

  void genGame() {
    moves = _startMoves;
    selectedCard = null;
    canSelect = true;
    cards = [];
    for (int i = 0; i < 12; i++) {
      cards.add(Card(i, i ~/ 2));
    }
    cards.shuffle();
  }

  Card findCardById(int id) {
    for (var card in cards) {
      if (card.id == id) return card;
    }
    throw ArgumentError("no card with id = \"$id\"", 'id');
  }

  void decrementMoves() => moves -= 1;

  GameStatus checkGameState() {
    if (moves == 0) return GameStatus.noMoves;
    for (var card in cards) {
      if (card.exists) return GameStatus.playing;
    }
    return GameStatus.finished;
  }
}
