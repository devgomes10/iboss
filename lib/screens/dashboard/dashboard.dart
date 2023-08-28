import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';
import '../../repositories/personal/fixed_entry_repository.dart';
import '../../repositories/personal/fixed_outflow_repository.dart';
import '../../repositories/personal/variable_entry_repository.dart';
import '../../repositories/personal/variable_outflow_repository.dart';

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
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Painel'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.gear),
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
                  const TabBar(
                    tabs: [
                      Tab(
                        text: 'Receitas',
                      ),
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
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
                                                title: real
                                                    .format(totalCashPayments),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalDeferredPayments,
                                                title: real.format(
                                                    totalDeferredPayments),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format(totalCashPayments +
                                                        totalDeferredPayments),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Pendentes'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Pagos'),
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: totalFixedExpenses + totalVariableExpense >
                                      0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalFixedExpenses,
                                                title: real
                                                    .format(totalFixedExpenses),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalVariableExpense,
                                                title: real.format(
                                                    totalVariableExpense),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format(
                                                        totalFixedExpenses +
                                                            totalVariableExpense),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Variável'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Fixo'),
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: totalFixedExpenses +
                                          totalVariableExpense +
                                          totalCashPayments +
                                          totalDeferredPayments >
                                      0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalCashPayments +
                                                    totalDeferredPayments,
                                                title: real.format(
                                                    totalCashPayments +
                                                        totalDeferredPayments),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalFixedExpenses +
                                                    totalVariableExpense,
                                                title: real.format(
                                                    totalFixedExpenses +
                                                        totalVariableExpense),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Saldo',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format((totalCashPayments +
                                                            totalDeferredPayments) -
                                                        (totalFixedExpenses +
                                                            totalVariableExpense)),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Gastos'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Receitas'),
                              ],
                            )
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
                  const TabBar(
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: totalFixedEntry + totalVariableEntry > 0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalFixedEntry,
                                                title: real
                                                    .format(totalFixedEntry),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalVariableEntry,
                                                title: real
                                                    .format(totalVariableEntry),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format(
                                                      (totalFixedEntry +
                                                          totalVariableEntry),
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Variável'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Fixo'),
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: totalFixedOutflow + totalVariableOutflow >
                                      0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalFixedOutflow,
                                                title: real
                                                    .format(totalFixedOutflow),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalVariableOutflow,
                                                title: real.format(
                                                    totalVariableOutflow),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format(
                                                      (totalFixedOutflow +
                                                          totalVariableOutflow),
                                                    ),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Variável'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Fixo'),
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
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR')
                                        .format(_selectedDate),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(
                                        FontAwesomeIcons.caretRight),
                                    onPressed: () => _changeMonth(true),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: totalFixedOutflow +
                                          totalVariableOutflow +
                                          totalFixedEntry +
                                          totalVariableEntry >
                                      0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalFixedEntry +
                                                    totalVariableEntry,
                                                title: real.format(
                                                    totalFixedEntry +
                                                        totalVariableEntry),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              PieChartSectionData(
                                                color: Colors.blue,
                                                value: totalFixedOutflow +
                                                    totalVariableOutflow,
                                                title: real.format(
                                                    totalFixedOutflow +
                                                        totalVariableOutflow),
                                                titleStyle: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                                  const Text(
                                                    'Saldo',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    real.format(
                                                      (totalFixedEntry +
                                                              totalVariableEntry) -
                                                          (totalFixedOutflow +
                                                              totalVariableOutflow),
                                                    ),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Text('Sem registros'),
                                    ),
                            ),
                            const SizedBox(
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
                                const SizedBox(width: 4),
                                const Text('Saídas'),
                                const SizedBox(width: 70),
                                Container(
                                  color: Colors.green,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text('Entradas'),
                              ],
                            )
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
