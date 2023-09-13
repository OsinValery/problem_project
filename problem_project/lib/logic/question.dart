class Question {
  int correctAnswer;
  String text;
  List<String> options;

  Question(this.text, this.correctAnswer, this.options);

  bool isCorrect(int option) => option == correctAnswer;
}
