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
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

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

    final fixedEntryRepository = Provider.of<FixedEntryRepository>(context);
    totalFixedEntry =
        fixedEntryRepository.getTotalFixedEntryByMonth(_selectedDate);
    final variableEntryRepository =
    Provider.of<VariableEntryRepository>(context);
    totalVariableEntry =
        variableEntryRepository.getTotalVariableEntryByMonth(_selectedDate);

    final fixedOutflowRepository = Provider.of<FixedOutflowRepository>(context);
    totalFixedOutflow =
        fixedOutflowRepository.getTotalFixedOutflowByMonth(_selectedDate);
    final variableOutflowRepository =
    Provider.of<VariableOutflowRepository>(context);
    totalVariableOutflow =
        variableOutflowRepository.getTotalVariableOutflowByMonth(_selectedDate);

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
                      Tab(text: 'Receitas'),
                      Tab(text: 'Gastos'),
                      Tab(text: 'Saldo'),
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
                            SizedBox(height: 25,),
                            Container(
                              width: 250,
                              height: 250,
                              child: totalCashPayments + totalDeferredPayments >
                                  0
                                  ? Stack(
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          color: Colors.green,
                                          value: totalCashPayments,
                                          title: '${real.format(totalCashPayments)}',
                                          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        PieChartSectionData(
                                          color: Colors.blue,
                                          value: totalDeferredPayments,
                                          title: '${real.format(totalDeferredPayments)}',
                                          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('${real.format(totalCashPayments + totalDeferredPayments)}',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                                  : Center(
                                child: Text(
                                    'Vocâ não recebeu nenhum pagamento esse mês'),
                              ),
                            ),SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  color: Colors.blue,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 4),
                                Text('A prazo'),
                                SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('À vista'),
                              ],
                            )
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
                            SizedBox(height: 25,),
                            Container(
                              width: 250,
                              height: 250,
                              child: totalVariableExpense + totalFixedExpenses >
                                  0
                                  ? Stack(
                                children: [
                                  PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          color: Colors.green,
                                          value: totalFixedExpenses,
                                          title: '${real.format(totalFixedExpenses)}',
                                          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                        PieChartSectionData(
                                          color: Colors.blue,
                                          value: totalVariableExpense,
                                          title: '${real.format(totalVariableExpense)}',
                                          titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('${real.format(totalVariableExpense + totalFixedExpenses)}',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                                  : Center(
                                child: Text(
                                    'Vocâ não recebeu nenhum pagamento esse mês'),
                              ),
                            ),SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  color: Colors.blue,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(width: 4),
                                Text('Fixo'),
                                SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('Variável'),
                              ],
                            )
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
                              child: totalCashPayments +
                                  totalDeferredPayments +
                                  totalFixedExpenses +
                                  totalVariableExpense >
                                  0
                                  ? PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: totalCashPayments +
                                            totalDeferredPayments,
                                        title: 'A'),
                                    PieChartSectionData(
                                        value: totalFixedExpenses +
                                            totalVariableExpense,
                                        title: 'B'),
                                  ],
                                ),
                              )
                                  : Center(
                                child: Text("Não há saldo esse mês"),
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
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Entradas'),
                      Tab(text: 'Saídas'),
                      Tab(text: 'Saldo'),
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
                                    PieChartSectionData(
                                        value: totalVariableEntry,
                                        title: 'A'),
                                    PieChartSectionData(
                                        value: totalFixedEntry,
                                        title: 'B'),
                                  ],
                                ),
                              )
                                  : Center(
                                child: Text(
                                    'Vocâ não recebeu nenhuma entrada esse mês'),
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
                              totalFixedOutflow + totalVariableOutflow > 0
                                  ? PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: totalFixedOutflow,
                                        title: 'A'),
                                    PieChartSectionData(
                                        value: totalVariableOutflow,
                                        title: 'B'),
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
                              child: totalFixedEntry + totalVariableEntry + totalFixedOutflow + totalVariableOutflow >
                                  0
                                  ? PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                        value: totalFixedEntry + totalVariableEntry,
                                        title: 'A'),
                                    PieChartSectionData(
                                        value: totalFixedOutflow + totalVariableOutflow,
                                        title: 'B'),
                                  ],
                                ),
                              )
                                  : Center(
                                child: Text("Não há saldo esse mês"),
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
