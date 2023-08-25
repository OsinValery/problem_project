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
    "Who protects the gate?",
    0,
    ['Goalkeeper', 'Striker', "Wing", 'Nobody'],
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
    "How many meters can sprinters run in competitions?",
    1,
    ['70 m', "30 m", '120 m', "300 m"],
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
    "The world record of lifting the barbell in kilograms",
    3,
    ['497.5', '421.5', '405', '477'],
  ),
  Question(
    "World record of throwing a shot",
    3,
    ["23.45", "22.72 m", "23.12 m", "23.37 m", "24.15", "23.76"],
  ),
  Question(
    "Year of birth of Wilhelm Steinitz",
    2,
    ['1893', '1963', '1836', '1950'],
  ),
  Question(
    "Where did football come up?",
    0,
    ['Britain', 'USA', 'Scotland', 'Brasil'],
  ),
  Question(
    "Maximal playing time in Volleyball",
    3,
    ['52 min', '48 min', '1h 12min', '57 min'],
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
    "the current world draughts champion",
    1,
    [
      'Alexey Chizhikov',
      'Rule Bomstra',
      'Anatoly Gantvarg',
      'Alexander Georgiev'
    ],
  ),
  Question(
    "The final score of the FIFA World Cup France-Croatia in 2018",
    2,
    ['2:4', "3:2", '4:2', '3:3', "2:1", "1:2"],
  ),
  Question(
    "Where was the World Ski Championships held in 1997?",
    2,
    ["Canada", "Denmark", "Norway", "Slovenia"],
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
