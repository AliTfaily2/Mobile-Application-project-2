import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'signin.dart';
import 'quiz.dart';
import 'stats.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: h * 0.01,),
            Image.asset('assets/logo.png'),
            SizedBox(height: h * 0.05,),
            const OperationButtons(operation: '+', image: 'assets/addition.png', text: 'ADD'),
            SizedBox(height: h*0.02,),
            const OperationButtons(operation: '-', image: 'assets/subtraction.png', text: 'SUBTRACT'),
            SizedBox(height: h*0.02,),
            const OperationButtons(operation: 'x', image: 'assets/multiplication.png', text: 'MULTIPLY'),
            SizedBox(height: h*0.02,),
            const OperationButtons(operation: '/', image: 'assets/division.png', text: 'DIVIDE'),
            SizedBox(height: h*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> const Stats())
                  );
                }, icon: const Icon(Icons.insert_chart,size: 50,color: Colors.black)),
                IconButton(onPressed: () {
                  _encryptedData.remove('myKey').then((success) {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const SignIn())
                    );
                  });
                }, icon: const Icon(Icons.logout,size: 40,color: Colors.black,)),
              ],
            ),

            SizedBox(height: h * 0.06,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Version 2.0.6 ', style: TextStyle(color: Colors.black54),),
                Text('\u00a92024 AliTfaily. All rights reserved', style: TextStyle(color: Colors.black54),)
              ],
            ),

          ],
        ),
      ),
    );
  }
}
class OperationButtons extends StatelessWidget {
  final String operation;
  final String image;
  final String text;
  const OperationButtons({required this.operation,required this.image,required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        SizedBox(height: 100,child:
        ElevatedButton(onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MyQuiz(operation: operation,))
          );
        },style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent,fixedSize: const Size(150, 50)), child: Image.asset(image, width: 125, height: 125,),)
        ),
        Text(text, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
      ],
    );
  }
}
