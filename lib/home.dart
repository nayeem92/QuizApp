import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app_tut/answer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.sports_soccer_rounded,
                color: Colors.green,

              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Football Quiz App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/soccer.jpg'),
            fit: BoxFit.cover,
          ),
        ),

       child: Center(

        child: Column(
          children: [
            Container(color: Colors.white,
            child: Row(
              children: [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 25.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                        ? Colors.green
                        : Colors.red
                    : Colors.white,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(80.0, 40.0),


              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected
                        ? 'CORRECT'
                        : 'INCORRECT',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? 'Your final score is: $_totalScore  Well done'
                        : 'Your final score is: $_totalScore  Nice Try',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    );
  }
}

final _questions = const [
  {
    'question': 'Who won BALONDOR 2019?',
    'answers': [
      {'answerText': 'Messi', 'score': true},
      {'answerText': 'Ronaldo', 'score': false},
      {'answerText': 'Lewandowski', 'score': false},
    ],
  },
  {
    'question':
        'Which Nation has won the most World Cups?',
    'answers': [
      {'answerText': 'Argentina', 'score': false},
      {'answerText': 'Italy', 'score': false},
      {'answerText': 'Brazil', 'score': true},
    ],
  },
  {
    'question': 'Where will the next world cup take place?',
    'answers': [
      {'answerText': 'UAE', 'score': false},
      {'answerText': 'England', 'score': false},
      {'answerText': 'Qatar', 'score': true},
    ],
  },
  {
    'question': 'Who is the biggest transfer in football in terms of money?',
    'answers': [
      {'answerText': 'Messi', 'score': false},
      {'answerText': 'Neymar', 'score': true},
      {'answerText': 'Mbappe', 'score': false},
    ],
  },
  {
    'question':
        'Current UCL winner?',
    'answers': [
      {'answerText': 'Chelsea', 'score': true},
      {'answerText': 'Manchester City', 'score': false},
      {'answerText': 'PSG', 'score': false},
    ],
  },
  {
    'question': 'Icardi is a ___',
    'answers': [
      {'answerText': 'Cheater', 'score': true},
      {'answerText': 'Goal Scorer', 'score': false},
      {'answerText': 'Goalkeeper', 'score': false},
    ],
  },
  {
    'question': 'Who is known as The Special One?',
    'answers': [
      {'answerText': 'Mourinho', 'score': true},
      {'answerText': 'Messi', 'score': false},
      {'answerText': 'Muller', 'score': false},
    ],
  },
  {
    'question': 'Which manager went a whole EPL season unbeaten?',
    'answers': [
      {'answerText': 'Zidane', 'score': false},
      {'answerText': 'Guardiola', 'score': false},
      {'answerText': 'Wenger', 'score': true},
    ],
  },
  {
    'question': 'Most earned athlete in the world?',
    'answers': [
      {'answerText': 'Lionel Messi', 'score': false},
      {'answerText': 'Tyson Fury', 'score': false},
      {'answerText': 'Conor McGregor', 'score': true},
    ],
  },
];
