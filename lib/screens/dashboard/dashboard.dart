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
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalCashPayments,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.blue,
                                                value: totalDeferredPayments,
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Pendentes',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalDeferredPayments)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Pagos',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalCashPayments)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
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
                              child:
                                  totalFixedExpenses + totalVariableExpense > 0
                                      ? Stack(
                                          children: [
                                            PieChart(
                                              PieChartData(
                                                sections: [
                                                  PieChartSectionData(
                                                    showTitle: false,
                                                    color: Colors.green,
                                                    value: totalFixedExpenses,
                                                  ),
                                                  PieChartSectionData(
                                                    showTitle: false,
                                                    color: Colors.blue,
                                                    value: totalVariableExpense,
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Variável',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalVariableExpense)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Fixo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalFixedExpenses)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
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
                                          totalCashPayments >
                                      0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalCashPayments,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.blue,
                                                value: totalFixedExpenses +
                                                    totalVariableExpense,
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
                                                    real.format((totalCashPayments) -
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Gastos',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(
                                        totalFixedExpenses +
                                            totalVariableExpense,
                                      )}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Recebidos',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalCashPayments)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
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
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalFixedEntry,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.blue,
                                                value: totalVariableEntry,
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Variável',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalVariableEntry)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Fixo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalFixedEntry)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
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
                              child:
                                  totalFixedOutflow + totalVariableOutflow > 0
                                      ? Stack(
                                          children: [
                                            PieChart(
                                              PieChartData(
                                                sections: [
                                                  PieChartSectionData(
                                                    showTitle: false,
                                                    color: Colors.green,
                                                    value: totalFixedOutflow,
                                                  ),
                                                  PieChartSectionData(
                                                    showTitle: false,
                                                    color: Colors.blue,
                                                    value: totalVariableOutflow,
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Variável',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalVariableOutflow)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Fixo',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalFixedOutflow)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
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
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalFixedEntry +
                                                    totalVariableEntry,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.blue,
                                                value: totalFixedOutflow +
                                                    totalVariableOutflow,
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
                                const SizedBox(width: 4),
                                Column(
                                  children: [
                                    const Text(
                                      'Saídas',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalFixedOutflow + totalVariableOutflow)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 70),
                                const SizedBox(
                                  width: 4,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Entradas',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${real.format(totalFixedEntry + totalVariableEntry)}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
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
