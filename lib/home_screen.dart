import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X';
  int turn = 0;
  String result = '';
  bool isSwitched = false;
  bool gameOver = false;
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SafeArea(
            child: MediaQuery.of(context).orientation == Orientation.portrait?
            Column(
          children: [
            ...firstBlock(),
            expanded1(context),
            ...lastBlock(),
          ],
        ):
        Row(
          children: [
            Expanded(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...firstBlock(),
                const SizedBox(height: 8,),
                ...lastBlock(),
              ],
            )),
            expanded1(context)          ],
        )
        ),
      ),
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            'Turn on/off two player',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (newVal) => setState(() {
                isSwitched = newVal;
              })),
      Text( (gameOver || turn == 9)?'Game Over':
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            turn = 0;
            result = '';
            gameOver = false;
            activePlayer = 'X';
            isSwitched = false;
          });
        },
        label: const Text('Repeat the game'),
        icon: const Icon(Icons.replay),
        style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).splashColor)),
      )
    ];
  }

  Expanded expanded1(BuildContext context) {
    return Expanded(
        child: GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      crossAxisSpacing: 8.0,
      children: List.generate(
          9,
          (index) => InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: (gameOver || turn == 9)? null: () =>  _onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      Player.playerX.contains(index)
                          ? 'X'
                          : Player.playerO.contains(index)
                              ? 'O'
                              : '',
                      style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.red
                              : Colors.blue,
                          fontSize: 52),
                    ),
                  ),
                ),
              )),
    ));
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();

      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;
        result = '$winnerPlayer is The winner';
      } else if (turn == 9 && !gameOver) {
        result = 'It\'s a Draw';
      }
    });
  }
}
