import 'package:problem_project/logic/question.dart';

class QuestionsRepository {
  List<Question> getQuestions({int n = 5}) {
    if (n > questions.length) n = questions.length;
    questions.shuffle();
    return questions.sublist(0, n);
  }
}

List<Question> questions = [
  Question(
    'How many goals has Ronaldo scored in his entire career?',
    0,
    ['681', '723', '597', "625"],
  ),
  Question(
    "How many impossible moves player can make in chess and don't lose?",
    2,
    ["0", '1', '2', '3', '5', '∞'],
  ),
  Question(
    "Who is basketball player?",
    1,
    ['David Beckham', 'Michael Jordan', 'Roger Federer', "Rafael Nadal"],
  ),
  Question(
    "Select unexisting swimming style",
    5,
    [
      "Sidestroke",
      "Butterfly",
      "Breaststroke",
      "Backstroke",
      "Freestyle",
      "WindStyle"
    ],
  ),

  Question(
    "How many types of pieces are there in chess?",
    0,
    ['6', '8', '5', '7'],
  ),
  Question(
    "Where were the first modern Olympic Games held?",
    1,
    ['Italy', 'Athens', 'Parthenon', 'Olympia'],
  ),
  Question(
    "What kind of sport doesn't exist?",
    4,
    [
      'Throwing towels',
      'Charming worms',
      'Cheese race',
      'Racing on beds',
      "Bugs race",
      "Pumpkin regatta"
    ],
  ),

  Question(
    "Where did football come up?",
    0,
    ['Britain', 'USA', 'Scotland', 'Brasil'],
  ),

  Question(
    'The most productive cricketer',
    0,
    [
      'Glenn Makgart',
      "Brad Hodge",
      "Jimmy Adams",
      "Craig Kieswetter",
      "Laurie Evans",
      "James Vince"
    ],
  ),



  Question(
    "In what kind of sport is ice rubbed?",
    3,
    ["Ice skating", "Cricket", "No such", "Curling"],
  ),
  Question(
    "How many people are on the bobsleigh team?",
    0,
    ["2 or 4", "8 or 6", "3 or 5", "5 or 6", "3 or 4", "4 or 5"],
  ),
  Question(
    "Is darts an Olympic sport?",
    1,
    ["Never", "Once", "Yes", "2 times"],
  ),
];
