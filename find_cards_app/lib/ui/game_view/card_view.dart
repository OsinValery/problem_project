import 'package:find_cards_app/ui/game_view/game_view_bloc.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/card.dart';

class CardView extends StatelessWidget {
  const CardView({super.key, required this.width, required this.card});

  final double width;
  final Card card;

  @override
  Widget build(BuildContext context) {
    double height = width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<GameBloc, GameState>(
        buildWhen: (_, state) =>
            ((state is SelectCardState) && ((state).cardId == card.id)) ||
            (state is HideAllCardsState) ||
            ((state is RemoveCardState) && (state.cardId == card.id)),
        builder: (context, state) {
          if (!card.exists) return EmptyCardView(height: height, width: width);
          if (state is SelectCardState) {
            // card selected, should flip it
            return OpenedCardView(
              width: width,
              height: height,
              type: card.type,
            );
          }

          return GestureDetector(
            onTap: () =>
                context.read<GameBloc>().add(FlipCardRequestEvent(card.id)),
            child: CardBackView(width: width, height: height, id: card.id),
          );
        },
      ),
    );
  }
}

class EmptyCardView extends StatelessWidget {
  const EmptyCardView({super.key, required this.height, required this.width});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.transparent,
    );
  }
}

class CardBackView extends StatelessWidget {
  const CardBackView({
    super.key,
    required this.height,
    required this.width,
    required this.id,
  });

  final double width;
  final double height;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(image: AssetImage("assets/card_back.png")),
      ),
      child: Center(
        child: Text(
          id.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class OpenedCardView extends StatelessWidget {
  const OpenedCardView({
    super.key,
    required this.width,
    required this.height,
    required this.type,
  });

  final double width;
  final double height;
  final int type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(5),
        image: DecorationImage(
          image: AssetImage("assets/$type.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
