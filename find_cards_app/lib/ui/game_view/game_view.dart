import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_view_bloc.dart';
import 'card_view.dart';

class GameBlocProvider extends StatelessWidget {
  final GameBloc bloc = GameBloc();
  final Widget child;

  GameBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>.value(value: bloc, child: child);
  }
}

/// main view
class GameView extends StatelessWidget {
  const GameView({super.key});

  void _presentGameResultView(BuildContext context, int moves, bool won) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context2) {
        return AlertDialog(
          title: Text(won ? "You won!" : "You lost!"),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Colors.brown.withAlpha(200),
          content: Text(
            won
                ? "You have $moves more moves after end of game!!"
                : "You lost, because you have not moves to continue!",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<GameBloc>().add(RestartGameEvent());
                },
                child: const Text("restart"),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBlocProvider(
      child: BlocListener<GameBloc, GameState>(
        listenWhen: (_, current) =>
            current is InitialState || current is GameFinishedState,
        listener: (context, state) {
          if (state is InitialState) {
            context.read<GameBloc>().add(RequestStateEvent());
          } else if (state is GameFinishedState) {
            _presentGameResultView(context, state.moves, state.reason);
          }
        },
        child: const GameContent(),
      ),
    );
  }
}

class GameContent extends StatelessWidget {
  const GameContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // set background image
        decoration: const BoxDecoration(
          color: Colors.brown,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/background.jpg"),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Center(
              child: BlocBuilder<GameBloc, GameState>(
                buildWhen: (_, current) => current is ChangeCounterState,
                builder: (context, state) {
                  var value = state is ChangeCounterState
                      ? state.value.toString()
                      : '0';
                  return Text(
                    "$value moves",
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 255, 215, 0),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            const Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: CardsSceneView(),
            )),
          ],
        ),
      ),
    );
  }
}

class CardsSceneView extends StatelessWidget {
  const CardsSceneView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var cardWidth = min(size.width, size.height) / 4;

    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) => current is SetCardsState,
      builder: (context, state) {
        if (state is! SetCardsState) return Container();

        var columnWidgets = List<Widget>.empty(growable: true);
        var rowWidgets = List<Widget>.empty(growable: true);

        for (int i = 0; i < state.countCards; i++) {
          rowWidgets.add(
            CardView(
              width: cardWidth,
              card: state.cards[i],
              key: Key(state.cards[i].hashCode.toString()),
            ),
          );
          if (rowWidgets.length == 3) {
            columnWidgets.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowWidgets,
            ));
            rowWidgets = [];
          }
        }
        if (rowWidgets.isNotEmpty) {
          columnWidgets.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowWidgets,
          ));
        }

        return ListView(
          shrinkWrap: true,
          children: columnWidgets,
        );
      },
    );
  }
}
