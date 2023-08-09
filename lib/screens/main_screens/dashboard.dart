import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();

  void _changeMonth(bool increment) {
    setState(() {
      if (increment) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Painel'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
              icon: FaIcon(FontAwesomeIcons.gear),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.industry),
                text: 'Empresa',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.userLarge),
                text: 'Pessoal',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _changeMonth(false),
                  ),
                  Text(
                    DateFormat.yMMMM('pt_BR').format(_selectedDate),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _changeMonth(true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Receitas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView(
                          children: [Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      value: 5,
                                      title: 'À vista',
                                      color: Colors.blue,
                                      radius: 50,
                                    ),
                                    PieChartSectionData(
                                      value: 3,
                                      title: 'A prazo',
                                      color: Colors.red,
                                      radius: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),

                      ],
                    ),
                  ),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
