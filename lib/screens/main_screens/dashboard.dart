import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/repositories/deferred_payment_repository.dart';
import 'package:iboss/repositories/fixed_expense_repository.dart';
import 'package:iboss/repositories/fixed_outflow_repository.dart';
import 'package:iboss/repositories/variable_expense_repository.dart';
import 'package:iboss/repositories/variable_outflow_repository.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/cash_payment_repository.dart';
import '../../repositories/fixed_entry_repository.dart';
import '../../repositories/variable_entry_repository.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime _selectedDate = DateTime.now();
  double totalCashPayments = 0.0;
  double totalDeferredPayments = 0.0;

  double totalFixedExpenses = 0.0;
  double totalVariableExpense = 0.0;

  double totalFixedEntry = 0.0;
  double totalVariableEntry = 0.0;

  double totalFixedOutflow = 0.0;
  double totalVariableOutflow = 0.0;

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
    totalCashPayments =
        cashPaymentRepository.getTotalCashPaymentsByMonth(_selectedDate);
    final deferredPaymentRepository =
        Provider.of<DeferredPaymentRepository>(context);
    totalDeferredPayments = deferredPaymentRepository
        .getTotalDeferredPaymentsByMonth(_selectedDate);

    final fixedExpenseRepository = Provider.of<FixedExpenseRepository>(context);
    totalFixedExpenses =
        fixedExpenseRepository.getTotalFixedExpensesByMonth(_selectedDate);
    final variableExpensesRepository =
        Provider.of<VariableExpenseRepository>(context);
    totalVariableExpense = variableExpensesRepository
        .getTotalVariableExpensesByMonth(_selectedDate);

    final fixedEntryRepository =
    Provider.of<FixedEntryRepository>(context);
    totalFixedEntry = fixedEntryRepository
        .getTotalFixedEntryByMonth(_selectedDate);
    final variableEntryRepository =
    Provider.of<VariableEntryRepository>(context);
    totalVariableEntry = variableEntryRepository
        .getTotalVariableEntryByMonth(_selectedDate);

    final fixedOutflowRepository =
    Provider.of<FixedOutflowRepository>(context);
    totalFixedOutflow = fixedOutflowRepository
        .getTotalFixedOutflowByMonth(_selectedDate);
    final variableOutflowRepository =
    Provider.of<VariableOutflowRepository>(context);
    totalVariableOutflow = variableOutflowRepository
        .getTotalVariableOutflowByMonth(_selectedDate);


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
                              child:
                                  totalCashPayments + totalDeferredPayments > 0
                                      ? PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                  value: totalCashPayments,
                                                  title: 'À vista'),
                                              PieChartSectionData(
                                                  value: totalDeferredPayments,
                                                  title: 'A prazo'),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                              'Vocâ não recebeu nenhum pagamento esse mês'),
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
                              child:
                                  totalFixedExpenses + totalVariableExpense > 0
                                      ? PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                  value: totalFixedExpenses,
                                                  title: 'A'),
                                              PieChartSectionData(
                                                  value: totalVariableExpense,
                                                  title: 'B'),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                              'Vocâ não teve nenhum gasto esse mês'),
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
                                    PieChartSectionData(value: 60, title: 'A'),
                                    PieChartSectionData(value: 40, title: 'B'),
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
                      Tab(text: 'Entradas'),
                      Tab(text: 'Saídas'),
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
                              child: totalFixedEntry + totalVariableEntry > 0
                                  ? PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(value: totalVariableEntry, title: 'A'),
                                    PieChartSectionData(value: totalFixedEntry, title: 'B'),
                                  ],
                                ),
                              ) : Center(child: Text('Vocâ não recebeu nenhuma entrada esse mês'),),
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
                              child: totalFixedOutflow + totalVariableOutflow > 0
                                  ? PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(value: totalFixedOutflow, title: 'A'),
                                    PieChartSectionData(value: totalVariableOutflow, title: 'B'),
                                  ],
                                ),
                              ) : Center(child: Text('Vocâ não recebeu nenhum pagamento esse mês'),),
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
