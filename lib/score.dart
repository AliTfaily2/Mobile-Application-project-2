import 'package:flutter/material.dart';

class ScoreArgument {
  int timeSpent;
  int livesRemaining;

  ScoreArgument(this.timeSpent, this.livesRemaining);
}

class ShowScore extends StatelessWidget {
  const ShowScore({super.key});

  @override
  Widget build(BuildContext context) {
    ScoreArgument score =
        ModalRoute.of(context)!.settings.arguments as ScoreArgument;
    String displayTime() {
      if (score.timeSpent <= 60) return '${score.timeSpent}s';
      int minutes = score.timeSpent ~/ 60;
      int remain = score.timeSpent % 60;
      return '${minutes}m ${remain}s';
    }

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: const RadialGradient(radius: 1.5, colors: [
              Colors.lime,
              Colors.green,
              Colors.black,
            ]),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
              child: Column(
                  children: [
                    const SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                        }, icon: const Icon(Icons.home,size: 55,color: Colors.white,)),
                        const SizedBox(width: 210,),
                        IconButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, icon: const Icon(Icons.refresh_rounded,size: 55,color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 140,),
                    const Text('You used',style:TextStyle(fontSize: 30, color: Colors.white)),
                    Text(displayTime(), style: const TextStyle(fontSize: 90, color: Colors.white),),
                    const Text('and',style:TextStyle(fontSize: 30, color: Colors.white)),
                    Text('${3 - score.livesRemaining}',style: const TextStyle(fontSize: 110, color: Colors.white)),
                    const Text('Hearts',style:TextStyle(fontSize: 30, color: Colors.white)),

              ]
              )
          )
      ),
    );
  }
}
