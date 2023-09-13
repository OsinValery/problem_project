import 'package:find_cards_app/logic/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:find_cards_app/logic/game_state.dart' as logic;

part 'events_and_states.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(InitialState()) {
    // events
    on<RequestStateEvent>(_startGame);
    on<RestartGameEvent>(_startGame);
    on<FlipCardRequestEvent>(_flipCard);
    on<TestEvent>(_test);

    Future.delayed(
      const Duration(milliseconds: 1),
      () => add(RequestStateEvent()),
    );
  }

  _startGame(RequestStateEvent _, Emitter emitter) {
    var gameState = logic.GameState();
    gameState.genGame();
    emitter(ChangeCounterState(gameState.moves));
    emitter(SetCardsState(
      cards: gameState.cards,
      countCards: gameState.cards.length,
    ));
  }

  _flipCard(FlipCardRequestEvent event, Emitter emitter) async {
    int id = event.cardId;
    var gameState = logic.GameState();
    if (gameState.selectedCard?.id == id) return;
    if (!gameState.canSelect) return;

    gameState.decrementMoves();
    emitter(ChangeCounterState(gameState.moves));

    if (gameState.selectedCard == null) {
      gameState.selectedCard = gameState.findCardById(id);
      emitter(SelectCardState(id));
    } else {
      gameState.canSelect = false;
      emitter(SelectCardState(id));
      await Future.delayed(const Duration(seconds: 2));
      var card = gameState.findCardById(id);

      if (gameState.selectedCard!.matches(card)) {
        card.remove();
        gameState.selectedCard?.remove();
        emitter(RemoveCardState(id));
        emitter(RemoveCardState(gameState.selectedCard!.id));
      } else {
        // wrong
        emitter(HideAllCardsState());
      }

      gameState.selectedCard = null;

      // check game status
      var status = gameState.checkGameState();

      switch (status) {
        case logic.GameStatus.playing:
          gameState.canSelect = true;
          break;
        case logic.GameStatus.noMoves:
        case logic.GameStatus.finished:
          await Future.delayed(const Duration(seconds: 2));
          emitter(GameFinishedState(
            gameState.moves,
            status == logic.GameStatus.finished,
          ));
      }
    }
  }

  _test(TestEvent event, Emitter emitter) {
    emitter(InitialState());
    // ignore: avoid_print
    print("test!!!");
  }
}
