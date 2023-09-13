part of 'game_view_bloc.dart';

abstract class GameState {}

final class ChangeCounterState extends GameState {
  int value;
  ChangeCounterState(this.value);
}

final class InitialState extends GameState {}

final class SetCardsState extends GameState {
  int countCards;
  List<Card> cards;
  SetCardsState({required this.cards, required this.countCards});
}

final class RemoveCardState extends GameState {
  int cardId;
  RemoveCardState(this.cardId);
}

final class HideAllCardsState extends GameState {}

final class GameFinishedState extends GameState {
  /// true if won, false if lose
  bool reason;
  int moves;
  GameFinishedState(this.moves, this.reason);
}

// -----------------------------------------------------
// events
// ----------------------------------------------------

abstract class GameEvent {}

final class RequestStateEvent extends GameEvent {}

final class RestartGameEvent implements RequestStateEvent {}

final class FlipCardRequestEvent extends GameEvent {
  int cardId;
  FlipCardRequestEvent(this.cardId);
}

final class SelectCardState extends GameState {
  int cardId;
  SelectCardState(this.cardId);
}

final class TestEvent extends GameEvent {}
