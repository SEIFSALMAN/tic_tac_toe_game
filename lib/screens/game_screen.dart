import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../logic/game_logic.dart';
import '../styles/color.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  int playerOneWins = 0;
  int playerTwoWins = 0;

  Game game = Game();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initializeGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      game.board = Game.initializeGameBoard();
                      if (lastValue == "X") {
                        lastValue = "O";
                      } else if(lastValue == "O"){
                        lastValue = "X";
                      }
                      gameOver = false;
                      turn = 0;
                      result = "";
                      scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                    });
                  },
                  child: Row(
                    children: [
                      Text("Restart", style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        Icons.restart_alt,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
            elevation: 0,
            title: Text(" Tic Tac Toe", style: TextStyle(color: Colors.white)),
            backgroundColor: MainColor.primaryColor),
        backgroundColor: MainColor.primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: 50,),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Player X",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text("$playerOneWins",
                            style: TextStyle(color: Colors.white, fontSize: 25))
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Player O",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text("$playerTwoWins",
                            style: TextStyle(color: Colors.white, fontSize: 25))
                      ],
                    ),
                  ],
                ),
                result == ""
                    ? SizedBox(
                        height: 1,
                      )
                    : SizedBox(height: 30),

                Text(
                  result,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 1,
                ),
                Container(
                  width: boardWidth,
                  height: boardWidth,
                  child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: Game.boardLenght ~/ 3,
                    padding: EdgeInsets.all(20),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(Game.boardLenght, (index) {
                      return InkWell(
                        radius: 0,
                        onTap: gameOver
                            ? null
                            : () {
                                if (game.board![index] == "") {
                                  HapticFeedback.mediumImpact();
                                  setState(() {
                                    game.board![index] = lastValue;
                                    turn++;
                                    gameOver = game.winnerCheck(
                                        lastValue, index, scoreboard, 3);
                                    if (gameOver) {
                                      if (lastValue == "X") {
                                        playerOneWins++;
                                      } else if (lastValue == "O") {
                                        playerTwoWins++;
                                      }
                                      result = "$lastValue is the Winner!";
                                    } else if (!gameOver && turn == 9) {
                                      result = "It's Draw!";
                                      gameOver = true;
                                    }
                                    if (lastValue == "X") {
                                      lastValue = "O";
                                    } else {
                                      lastValue = "X";
                                    }
                                    print(game.board);
                                  });
                                }
                              },
                        child: Container(
                          width: Game.blocSize,
                          height: Game.blocSize,
                          decoration: BoxDecoration(
                              color: game.board![index] == "X"
                                  ? MainColor.xBackColor
                                  : game.board![index] == "O"
                                      ? MainColor.oBackColor
                                      : Colors.grey.shade500,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Text(
                            game.board![index],
                            style: TextStyle(color: Colors.black, fontSize: 64),
                          )),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "It's $lastValue turn",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
