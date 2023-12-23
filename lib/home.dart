import 'package:flutter/material.dart';
import 'quiz.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80,),
            Image.asset('assets/logo.png'),
            const SizedBox(height: 30,),
            Row(
              children: [
                SizedBox(height: 100,child:
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const MyQuiz(operation: '+',))
                  );
                },style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent), child: Image.asset('assets/addition.png', width: 125, height: 125,),)
                ),
                const Text('ADD', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 20,),
                const Text('SUBTRACT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
                SizedBox(height: 100
                    ,child: ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const MyQuiz(operation: '-',))
                      );
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent), child: Image.asset('assets/subtraction.png', width: 125, height: 125,))
                )
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(height: 100,child:
                ElevatedButton(onPressed: (){
                 Navigator.of(context).push(
                   MaterialPageRoute(builder: (context) => const MyQuiz(operation: 'x',))
                 );
                },style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent), child: Image.asset('assets/multiplication.png', width: 125, height: 125,),)
                ),
                const Text('MULTIPLY', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                const SizedBox(width: 30,),
                const Text('DIVIDE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
                const SizedBox(width:57),
                SizedBox(height: 100
                    ,child: ElevatedButton(onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const MyQuiz(operation: '/',))
                      );
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent), child: Image.asset('assets/division.png', width: 125, height: 125,))
                )
              ],
            ),
            const SizedBox(height: 70,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Version 1.0.6 ', style: TextStyle(color: Colors.black54),),
                Text('\u00a92023 AliTfaily. All rights reserved', style: TextStyle(color: Colors.black54),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
