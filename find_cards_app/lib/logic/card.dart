class Card {
  int id;
  int type;
  bool exists = true;

  Card(this.id, this.type);

  bool matches(Card card) => card.type == type;
  void remove() => exists = false;
}
