import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/repositories/deferred_payment_repository.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../repositories/cash_payment_repository.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();
  double totalCashPayments = 0.0;
  double totalDeferredPayments = 0.0;

  void _changeMonth(bool increment) {
    setState(() {
      if (increment) {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else {
        _selectedDate =
            DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cashPaymentRepository = Provider.of<CashPaymentRepository>(context);
    totalCashPayments = cashPaymentRepository.getTotalCashPaymentsByMonth(_selectedDate);
    final deferredPaymentRepository = Provider.of<DeferredPaymentRepository>(context);
    totalDeferredPayments = deferredPaymentRepository.getTotalDeferredPaymentsByMonth(_selectedDate);

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
        body: TabBarView(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Receita'),
                      Tab(text: 'Gastos'),
                      Tab(text: 'Pró-labore'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: totalCashPayments, title: 'À vista'),
                                    PieChartSectionData(
                                        value: totalDeferredPayments, title: 'A prazo'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: 40, title: 'A'),
                                    PieChartSectionData(
                                        value: 30, title: 'B'),
                                    PieChartSectionData(
                                        value: 15, title: 'C'),
                                    PieChartSectionData(
                                        value: 15, title: 'D'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: 40, title: 'A'),
                                    PieChartSectionData(
                                        value: 30, title: 'B'),
                                    PieChartSectionData(
                                        value: 15, title: 'C'),
                                    PieChartSectionData(
                                        value: 15, title: 'D'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Receita'),
                      Tab(text: 'Gastos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: 40, title: 'A'),
                                    PieChartSectionData(
                                        value: 30, title: 'B'),
                                    PieChartSectionData(
                                        value: 15, title: 'C'),
                                    PieChartSectionData(
                                        value: 15, title: 'D'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.arrow_left),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.arrow_right),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 200,
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: 40, title: 'A'),
                                    PieChartSectionData(
                                        value: 30, title: 'B'),
                                    PieChartSectionData(
                                        value: 15, title: 'C'),
                                    PieChartSectionData(
                                        value: 15, title: 'D'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
