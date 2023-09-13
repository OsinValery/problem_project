import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:find_cards_app/ui/game_view/game_view.dart';
import '../url_view/url_view.dart';

import 'root_bloc.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RootBloc>(
      create: (_) => RootBloc(),
      child: const ViewSelector(),
    );
  }
}

class ViewSelector extends StatelessWidget {
  const ViewSelector({super.key});

  @override
  Widget build(BuildContext context) {
    var cobot = context.watch<RootBloc>();

    if (!cobot.state.conditionsChecked) {
      cobot.getStartState();
      return const NoStateView();
    } else if (!cobot.state.presentUrl || cobot.state.url.isEmpty) {
      return const GameView();
    } else if (!cobot.state.haveInternet) {
      return const NoInternetView();
    } else {
      //return const GameView();
      return UrlView(url: cobot.state.url);
    }
  }
}

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  void refresh(BuildContext context) {
    context.read<RootBloc>().refrashInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ProblemApp',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => refresh(context),
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: const Center(
        child: Text(
          'No internet connection',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class NoStateView extends StatelessWidget {
  const NoStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
