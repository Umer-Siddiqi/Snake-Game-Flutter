
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
 @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberofsquares = 760;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  void generatedNewFood() {
    food = randomNumber.nextInt(700);
  }

  void startGame() {
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 400);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
     });
  }


var direction = 'down';
void updateSnake(){
  setState((){
    switch(direction) {
      case 'down':
      if (snakePosition.last > 740) {
        snakePosition.add(snakePosition.last + 20 - 760);
      } else {
        snakePosition.add(snakePosition.last + 20);
      }
      break;

      case 'up':
      if (snakePosition.last < 20) {
        snakePosition.add(snakePosition.last - 20 + 760);
      } else {
        snakePosition.add(snakePosition.last - 20);
      }
      break;

      case 'left':
      if (snakePosition.last % 20 == 0) {
        snakePosition.add(snakePosition.last - 1 + 20);
      } else {
        snakePosition.add(snakePosition.last - 1);
      }
      break;

      case 'right':
      if ((snakePosition.last + 1) % 20 == 0) {
        snakePosition.add(snakePosition.last + 1 - 20);
      } else {
        snakePosition.add(snakePosition.last + 1);
      }
      break;

      default:
    }

    if(snakePosition.last == food) {
      generatedNewFood();
    } else {
      snakePosition.removeAt(0);
    }
  });
}

bool gameOver() {
  for (int i=0; i<snakePosition.length; i++) {
    int count = 0;
    for (int j=0; j<snakePosition.length; j++) {
      if (snakePosition[i] == snakePosition[j]) {
        count +=1;
    }
    if (count == 2) {
      return true;
    }
   }
  }
  return false;
}

void _showGameOverScreen() {
  showDialog(context: context,
   builder: (BuildContext context) {
    return AlertDialog(
      title: Text('GAME OVER'),
      content: Text('Your Score: ' + snakePosition.length.toString()),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Play Again'),
          onPressed : () {
            startGame();
            Navigator.of(context).pop();
          },
        )
      ],
    );
   }
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: Colors.black,
  body: Column(
    children: <Widget>[
      Expanded(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (direction != 'up' && details.delta.dy > 0) {
              direction = 'down';
            } else if (direction != 'down' && details.delta.dy < 0) {
              direction = 'up';
            }
          },
          onHorizontalDragUpdate: (details) {
            if (direction != 'left' && details.delta.dx > 0) {
              direction = 'right';
            } else if (direction != 'right' && details.delta.dx < 0) {
              direction = 'left';
            }
          },

          child: Container(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: numberofsquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 20),
              itemBuilder: (BuildContext context, int index) {
                if (snakePosition.contains(index)) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Color(0xFF008000),
                        ),
                      ),
                    ),
                  );
                }
                if (index == food) {
                  return Container(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Color(0xFFFF0000),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Color(0xFF404040),
                      ),
                    ),
                  );
                }
              }  
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: startGame,
                child: Text('START',
                style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Text(
                'created by Umer',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
          )
    ],
  ),
  );
}
}
