import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:problem_project/logic/question.dart';
import 'plug_bloc.dart';

class PlugView extends StatelessWidget {
  const PlugView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => GameCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Sport Quiz"),
          ),
          body: const SelectView(),
        ));
  }
}

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GameCubit>().state;

    if (state.isFinishing) {
      return const EndGameView(played: true);
    } else if (!state.isPlaying) {
      return const EndGameView(played: false);
    } else {
      return QuizView(question: state.question!, points: state.points);
    }
  }
}

class QuizView extends StatelessWidget {
  const QuizView({super.key, required this.question, required this.points});

  final Question question;
  final int points;

  void select(BuildContext context, int index) {
    context.read<GameCubit>().selectAnswer(index);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      var buttons = List.generate(
        question.options.length,
        (i) => ElevatedButton(
          onPressed: () => select(context, i),
          child: Text(question.options[i]),
        ),
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 1),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(210, 207, 164, 124),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Text(
                question.text,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Spacer(flex: 2),
          Flexible(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 4,
              shrinkWrap: true,
              children: buttons,
            ),
          )
        ],
      );
    });
  }
}

class EndGameView extends StatelessWidget {
  const EndGameView({super.key, this.played = false});

  final bool played;

  void pressed(BuildContext context) {
    context.read<GameCubit>().startGame();
  }

  @override
  Widget build(BuildContext context) {
    var texts = {true: "Restart", false: "Start game"};
    var state = context.read<GameCubit>().state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Spacer(),
        if (played)
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(210, 207, 164, 124),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Questions:'),
                    Text(state.countQuestions.toString())
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Correct:'),
                    Text(state.points.toString())
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Best Score:'),
                    Text(state.bestScore.toString())
                  ],
                ),
              ],
            ),
          ),
        Center(
          child: ElevatedButton(
            child: Text(texts[played]!),
            onPressed: () => pressed(context),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}
