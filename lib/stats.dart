import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _baseURL = 'http://alitfaily.000webhostapp.com';
final EncryptedSharedPreferences _encryptedData = EncryptedSharedPreferences();

List<String> filters = [
  'All',
  'Addition',
  'Subtraction',
  'Multiplication',
  'Division'
];

List<BarChartGroupData> barGraphList = [];
List<FlSpot> linegraphData = [];

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  String filter = filters.first;
  double wins = 0;
  double loses = 0;
  bool _loadPage = false;
  bool _loadChart = false;
  bool _loadbargraph = false;
  bool _loadlinegraph = false;
  String username = '';
  bool filterVisibility = false;

  void saveData(double w, double l) {
    setState(() {
      wins = w;
      loses = l;
      _loadPage = true;
      _loadChart = true;
    });
  }

  void refreshPage() {
    setState(() {
      wins = 0;
      loses = 0;
      _loadPage = false;
      _loadChart = false;
      _loadbargraph = false;
      _loadlinegraph = false;
      pieChartData(displayStatus, saveData, filter);
      barGraphData(displayStatus, update);
      lineGraph(displayStatus, updateLine, filter);
    });
  }

  void resetDataPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Data Reset'),
            content: const Text(
                'Are you sure that you want to delete all your data?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text(
                    'Go back',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                onPressed: () {
                  dataReset(displayStatus, refreshPage);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child:
                    const Text('Reset', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }

  void displayStatus(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void updateLine(bool success) {
    setState(() {
      _loadlinegraph = true;
    });
  }

  void update(bool success) {
    setState(() {
      _loadbargraph = true;
    });
  }

  void updateName(String name) {
    setState(() {
      username = 'Welcome, $name!';
    });
  }

  @override
  void initState() {
    pieChartData(displayStatus, saveData, filter);
    barGraphData(displayStatus, update);
    lineGraph(displayStatus, updateLine, filter);
    getUsername(updateName, displayStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'myStats',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(onPressed: (){
              setState(() {
                if(filterVisibility){
                  filterVisibility = false;
                }else{
                  filterVisibility = true;
                }

              });
            }, icon: const Icon(Icons.filter_alt)),
          ],
        ),
        body: !_loadPage
            ? const Center(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Center(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(visible: filterVisibility ,child:
                  DropdownMenu(
                    dropdownMenuEntries:
                        filters.map<DropdownMenuEntry<String>>((String text) {
                      return DropdownMenuEntry(value: text, label: text);
                    }).toList(),
                    initialSelection: filters.first,
                    onSelected: (String? text) {
                      setState(() {
                        filter = text as String;
                        _loadChart = false;
                        _loadlinegraph = false;
                        pieChartData(displayStatus, saveData, text);
                        lineGraph(displayStatus, updateLine, filter);
                      });
                    },
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: w *0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                            radius: 3,
                            colors: [
                              Colors.lime,
                              Colors.green,
                              Colors.black,
                            ]
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(child: Text(
                    'WIN/LOSS',
                    style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 2,),
                  ))),
                  !_loadChart
                      ? const Center(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Row(
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Wins: ${wins.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.green),
                                ),
                                Text(
                                  'Loses: ${loses.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.red),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 220,
                              height: 300,
                              child: PieChart(
                                PieChartData(
                                    centerSpaceRadius: 1,
                                    sectionsSpace: 0,
                                    sections: [
                                      PieChartSectionData(
                                        showTitle: false,
                                        value: wins,
                                        color: Colors.green,
                                        radius: 100,
                                      ),
                                      PieChartSectionData(
                                        showTitle: false,
                                        value: loses,
                                        color: Colors.red,
                                        radius: 100,
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: w *0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                            radius: 3,
                            colors: [
                              Colors.lime,
                              Colors.green,
                              Colors.black,
                            ]
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(child: Text(
                        'Time History',
                        style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 2,),
                      ))),
                  const SizedBox(height: 40,),
                  !_loadlinegraph
                      ? const Center(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          height: 430,
                          width: 300,
                          child: LineChart(LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                    spots: linegraphData,
                                    isCurved: true,
                                    color: Colors.green,
                                    barWidth: 3,
                                    belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.black.withOpacity(0.3)))
                              ],
                              titlesData: const FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                      axisNameWidget: Text('games won'),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                      )),
                                  leftTitles: AxisTitles(
                                      axisNameWidget: Text('seconds'),
                                      sideTitles: SideTitles(
                                          showTitles: true, reservedSize: 40)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false))))),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: w *0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                            radius: 3,
                            colors: [
                              Colors.lime,
                              Colors.green,
                              Colors.black,
                            ]
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(child: Text(
                        'GAMES/DAY',
                        style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 2,),
                      ))),
                  const SizedBox(height: 40,),
                  !_loadbargraph
                      ? const Center(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SizedBox(
                          width: 300,
                          height: 300,
                          child: BarChart(
                            BarChartData(
                                titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      interval: 3,
                                      getTitlesWidget: (value, meta) {
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 1:
                                            text = 'Sun';
                                            break;
                                          case 2:
                                            text = 'Mon';
                                            break;
                                          case 3:
                                            text = 'Tue';
                                            break;
                                          case 4:
                                            text = 'Wed';
                                            break;
                                          case 5:
                                            text = 'Thu';
                                            break;
                                          case 6:
                                            text = 'Fri';
                                            break;
                                          case 7:
                                            text = 'Sat';
                                            break;
                                        }
                                        return Text(text);
                                      },
                                    )),
                                    topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false))),
                                borderData: FlBorderData(
                                    border: const Border(
                                        top: BorderSide.none,
                                        right: BorderSide.none,
                                        left: BorderSide(width: 1),
                                        bottom: BorderSide(width: 1))),
                                groupsSpace: 10,
                                barGroups: [
                                  barGraphList[0],
                                  barGraphList[1],
                                  barGraphList[2],
                                  barGraphList[3],
                                  barGraphList[4],
                                  barGraphList[5],
                                  barGraphList[6]
                                ]),
                          )),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: resetDataPopup,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text(
                        'Reset Data',
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Version 2.0.6 ',
                        style: TextStyle(color: Colors.black54),
                      ),
                      Text(
                        '\u00a92024 AliTfaily. All rights reserved',
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                  const SizedBox(height: 10)
                ]),
              )));
  }
}

void getUsername(Function(String name) updateName,
    Function(String text) displayStatus) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/getUsername.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{'uid': userID}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      updateName(row['username']);
    }
  } catch (e) {
    displayStatus('Failed to set username');
  }
}

void pieChartData(Function(String message) displayStatus,
    Function(double wins, double loses) saveData, String operation) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/piechartData.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(
                <String, String>{'uid': userID, 'operation': operation}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      var row = jsonResponse[0];
      saveData(double.parse(row['wins']), double.parse(row['loses']));
    }
  } catch (e) {
    displayStatus('Error retrieving data');
  }
}

void barGraphData(Function(String message) displayStatus,
    Function(bool success) update) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/barGraph.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{'uid': userID}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      barGraphList.clear();
      for (var row in jsonResponse) {
        int x = int.parse(row['dayOfWeek']);
        double y = double.parse(row['numberOfGames']);
        barGraphList.add(BarChartGroupData(x: x, barRods: [
          BarChartRodData(borderRadius: BorderRadius.zero, toY: y, width: 20)
        ]));
      }
      if (barGraphList.length < 7) {
        for (var i = barGraphList.length; i < 7; i++) {
          barGraphList.add(BarChartGroupData(x: 0, barRods: [
            BarChartRodData(borderRadius: BorderRadius.zero, toY: 0, width: 20)
          ]));
        }
      }
      update(true);
    }
  } catch (e) {
    update(false);
    displayStatus('Error retrieving data');
  }
}

void lineGraph(Function(String message) displayStatus,
    Function(bool success) updateLine, String operation) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/linechartData.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(
                <String, String>{'uid': userID, 'operation': operation}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      linegraphData.clear();
      double count = 1;
      for (int i = jsonResponse.length - 1; i >= 0; i--) {
        var row = jsonResponse[i];
        double x = double.parse(row['timeTook']);
        linegraphData.add(FlSpot(count, x));
        count++;
      }
      updateLine(true);
    }
  } catch (e) {
    updateLine(false);
    displayStatus('Error retrieving data');
  }
}

void dataReset(
    Function(String message) displayStatus, Function() refreshPage) async {
  try {
    String userID = await _encryptedData.getString('myKey');
    final response = await http
        .post(Uri.parse('$_baseURL/mobile/dataReset.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: convert.jsonEncode(<String, String>{'uid': userID}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      displayStatus(response.body);
      refreshPage();
    }
  } catch (e) {
    displayStatus('Error deleting data');
  }
}
