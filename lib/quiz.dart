import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'score.dart';

const String _baseURL = 'http://alitfaily.000webhostapp.com';
EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

class MyQuiz extends StatefulWidget {
  final String operation;
  const MyQuiz({required this.operation,super.key});

  @override
  State<MyQuiz> createState() => _MyQuizState();
}

class _MyQuizState extends State<MyQuiz> {

  Random random = Random();
  double num1 = 0, num2 = 0, correctAnswer = 0;
  List<double> options = [];
  int lifeCounter = 3;
  int countdown = 10;
  late Timer timer;
  String header = '';
  int x = 0;
  int y = 39;
  Color colors = Colors.black;
  int count = 0;
  String hearts = '❤️❤️❤️';
  int timeTook = 0;

  @override
  void initState(){
    super.initState();
    startTimer();
    generateQuestion();
  }
  void saveRecords(String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  void startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeTook++;
        if(countdown > 0){
          countdown--;
        }
        else{
          lifeCounter--;
          colors = Colors.red;
          generateQuestion();
        }
      });
    });
  }
  void resetTimer(){
    setState(() {
      countdown = 10;
    });
  }

  void generateQuestion(){
    resetTimer();
    timer.cancel();
    if(count == 10){
      dataInsertion(saveRecords, header,'1', timeTook.toString());
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> const ShowScore(),
        settings: RouteSettings(arguments: ScoreArgument(timeTook,lifeCounter)))
      ).then((result) {
        setState(() {
          hearts = '❤️❤️❤️';
          lifeCounter = 3;
          count = 0;
          timeTook = 0;
        });
        generateQuestion();
      });
      return;
    }
    if(lifeCounter == 0){
      hearts= '💔💔💔';
      dataInsertion(saveRecords, header,'0', timeTook.toString());
      timer.cancel();
      showRestartDialog();
      return;
    }


    switch(widget.operation){
      case '+':
        num1 = random.nextInt(19) + 1.0;
        num2 = random.nextInt(19) + 1.0;
        correctAnswer = num1 + num2;
        header = 'Addition';
        break;
      case '-':
        num1 = random.nextInt(19) + 1.0;
        num2 = random.nextInt(19) + 1.0;
        correctAnswer = num1 - num2;
        header = 'Subtraction';
        break;
      case 'x':
        num1 = random.nextInt(9) +1.0;
        num2 = random.nextInt(9) +1.0;
        y = 100;
        correctAnswer = num1 * num2;
        header = 'Multiplication';
        break;
      case '/':
        num1 = random.nextInt(9) + 1.0;
        num2 = random.nextInt(9) + 1.0;
        correctAnswer = num1 / num2;
        x = 1;
        header = 'Division';
        break;
    }
    options = [correctAnswer];
    for(int i=0; i < 3; i++){
      double wrongAnswer = 0;
      if(widget.operation == '/') {
        wrongAnswer = random.nextDouble() * 10.0;
      }else{
        wrongAnswer = random.nextInt(y) * 1.0;
      }
      if(!options.contains(wrongAnswer)){
        options.add(wrongAnswer);
      }else{
        i--;
      }
    }
    switch(lifeCounter){
      case 2:
        hearts = '❤️❤️💔';
        break;
      case 1:
        hearts = '❤️💔💔';
        break;
    }
    options.shuffle();
    startTimer();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        colors = Colors.black;
      });
    });
  }
  void checkAnswer(double selectedAnswer){
    if(selectedAnswer == correctAnswer){
      setState(() {
        colors = Colors.green;
        count++;
      });
    }else{
      setState(() {
        colors = Colors.red;
        lifeCounter--;
      });
    }
    generateQuestion();
  }
  void showRestartDialog(){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You lost all your lives. Do you want to play again?'),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              hearts = '❤️❤️❤️';
              lifeCounter = 3;
              count = 0;
              generateQuestion();
            });
            Navigator.of(context).pop();
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Restart',style: TextStyle(color:Colors.white),)),
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Go Home',style: TextStyle(color:Colors.white)),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('MyQuiz - $header', style: const TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: colors,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24,),
            const Row(
                children: [
                  SizedBox(width: 85,),
                  Text("LIVES", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(width: 65,),
                  Text('TIME', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ]
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(hearts, style: const TextStyle(fontSize: 30)),
                Text('${countdown}s', style: const TextStyle(fontSize: 30),),
              ]
            ),
            const SizedBox(height:30),
            Container(
              width: 340,
              height: 150,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  radius: 1.5,
                  colors: [
                    Colors.lime,
                    Colors.green,
                    Colors.black,
                  ]
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(child: Text('${num1.toInt()} ${widget.operation} ${num2.toInt()}', style: const TextStyle(fontSize: 65,color: Colors.white),),)
            ),
            const SizedBox(height: 60,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                  timer.cancel();
                  checkAnswer(options[0]);
                },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black,  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                  child: Text(options[0].toStringAsFixed(x), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w300,color:Colors.white),),
                    )
                ),
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkAnswer(options[1]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(options[1].toStringAsFixed(x), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w300,color:Colors.white)),
                    )
                ),
              ],
            ),
            const SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkAnswer(options[2]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(options[2].toStringAsFixed(x), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w300,color:Colors.white)),
                    )
                ),
                SizedBox(height: 100,width: 120,
                    child: ElevatedButton(onPressed:(){
                      timer.cancel();
                      checkAnswer(options[3]);
                    },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0),),),
                      child: Text(options[3].toStringAsFixed(x), style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w300,color:Colors.white)),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void dataInsertion(Function(String text) saveRecords, String operation, String result,String tt) async{
  try{
    String userID = await _encryptedData.getString('myKey');
    final response = await http.post(
        Uri.parse('$_baseURL/mobile/dataInsertion.php'),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'uid': userID,
          'operation': operation,
          'result': result,
          'timetook': tt
        }))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      saveRecords(response.body);
    }
  }catch(e){
    saveRecords('connection error');
  }
}
