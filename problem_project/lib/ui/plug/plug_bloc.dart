import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:problem_project/logic/question.dart';
import 'package:problem_project/repositories/questions_repository.dart';
import 'package:problem_project/services/storage_service.dart';

class GameState {
  List<Question> selectedQuestions = [];
  int points = 0;
  int curQuestion = 0;

  Question getQuestion() => selectedQuestions[curQuestion];
  bool isEnd() => curQuestion == selectedQuestions.length - 1;
  void toNextQuestion() => curQuestion += 1;
}

class QuizState {
  Question? question;
  bool isPlaying = false;
  bool isFinishing = false;
  int points = 0;
  int bestScore = 0;
  int countQuestions = 12;

  @override
  operator ==(other) {
    if (other.runtimeType != QuizState) return false;
    return false;
  }

  @override
  int get hashCode =>
      points.hashCode ^
      isFinishing.hashCode ^
      isPlaying.hashCode ^
      question.hashCode ^
      bestScore.hashCode;
}

class GameCubit extends Cubit<QuizState> {
  GameCubit() : super(QuizState());

  final gameRepository = QuestionsRepository();
  final _storageService = StorageService();

  var gameState = GameState();
  var quizState = QuizState();

  void updateQuizState() {
    quizState.question = gameState.getQuestion();
    quizState.points = gameState.points;
  }

  void startGame() {
    gameState.points = 0;
    gameState.curQuestion = 0;
    gameState.selectedQuestions = gameRepository.getQuestions(n: 12);

    quizState.isPlaying = true;
    quizState.isFinishing = false;
    quizState.countQuestions = gameState.selectedQuestions.length;
    updateQuizState();
    emit(quizState);
    _storageService.getScore().then((value) {
      if (value != null) quizState.bestScore = value;
    });
  }

  void selectAnswer(int value) {
    if (quizState.question!.isCorrect(value)) {
      gameState.points += 1;
    }
    if (gameState.isEnd()) {
      updateQuizState();
      quizState.isFinishing = true;
      if (gameState.points > quizState.bestScore) {
        quizState.bestScore = gameState.points;
        _storageService.saveScore(quizState.bestScore);
      }
    } else {
      gameState.toNextQuestion();
      updateQuizState();
    }
    emit(quizState);
  }
}
