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

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  String filter = filters.first;
  double wins = 0;
  double loses = 0;
  bool _loadPage= false;
  bool _loadChart = false;
  void saveData(double w, double l) {
    setState(() {
      wins = w;
      loses = l;
      _loadPage = true;
      _loadChart = true;
    });
  }

  @override
  void initState() {
    pieChartData(saveData, filter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          elevation: 10,
        ),
        body: !_loadPage?const Center(child: SizedBox(width: 120,height: 120,child: CircularProgressIndicator(),),)
            :SingleChildScrollView(
            child: Center(
          child: Column(children: [
            const Text(
              'Choose a filter:',
              style: TextStyle(fontSize: 24),
            ),
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
                  pieChartData(saveData, text);
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'WIN/LOSS Chart:',
              style: TextStyle(fontSize: 24),
            ),
            !_loadChart?const Center(child: SizedBox(width: 120,height: 120,child: CircularProgressIndicator(),),):
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text(
                      'Wins: $wins',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    Text(
                      'Loses: $loses',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    )
                  ],
                ),
                Container(
                  width: 250,
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
            )
          ]),
        )));
  }
}

void pieChartData(
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
  } catch (e) {}
}
