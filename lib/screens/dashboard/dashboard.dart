import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';
import 'business_dash.dart';

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
  late Stream<List<double>> myStream;

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
            const BusinessDash(),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.caretLeft),
                                    onPressed: () => _changeMonth(false),
                                  ),
                                  Text(
                                    DateFormat.yMMMM('pt_BR').format(_selectedDate),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const FaIcon(FontAwesomeIcons.caretRight),
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
                              child: StreamBuilder<double>(
                                stream: CashPaymentRepository()
                                    .getTotalCashPaymentsByMonth(_selectedDate),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> cashSnapshot) {
                                  double totalCashPayments = cashSnapshot.data ?? 0.0;
                                  return StreamBuilder<double>(
                                    stream: DeferredPaymentRepository()
                                        .getTotalDeferredPaymentsByMonth(_selectedDate),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<double> deferredSnapshot) {
                                      double totalDeferredPayments =
                                          deferredSnapshot.data ?? 0.0;
                                      double total =
                                          totalCashPayments + totalDeferredPayments;
                                      return total > 0
                                          ? Stack(
                                        children: [
                                          PieChart(
                                            PieChartData(
                                              sections: [
                                                PieChartSectionData(
                                                  showTitle: false,
                                                  color: Colors.yellow,
                                                  value: totalDeferredPayments,
                                                ),
                                                PieChartSectionData(
                                                  showTitle: false,
                                                  color: Colors.green,
                                                  value: totalCashPayments,
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
                                                      real.format(total),
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
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                    StreamBuilder<double>(
                                      stream: CashPaymentRepository()
                                          .getTotalCashPaymentsByMonth(_selectedDate),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> cashSnapshot) {
                                        double totalCashPayments =
                                            cashSnapshot.data ?? 0.0;
                                        return StreamBuilder<double>(
                                          stream: FixedExpenseRepository()
                                              .getTotalFixedExpensesByMonth(_selectedDate),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<double> fixedSnapshot) {
                                            double totalFixedExpenses =
                                                fixedSnapshot.data ?? 0.0;
                                            return StreamBuilder<double>(
                                              stream: VariableExpenseRepository()
                                                  .getTotalVariableExpensesByMonth(
                                                  _selectedDate),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<double> variableSnapshot) {
                                                double totalVariableExpenses =
                                                    variableSnapshot.data ?? 0.0;
                                                double total =
                                                    totalFixedExpenses + totalVariableExpenses;
                                                return Text(
                                                  '${real.format(total)}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.yellow,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        );
                                        //   Text(
                                        //   '${real.format(totalCashPayments)}',
                                        //   style: TextStyle(
                                        //     fontSize: 20,
                                        //     color: Colors.green,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 70),
                                Column(
                                  children: [
                                    const Text(
                                      'Pendentes',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StreamBuilder<double>(
                                      stream: DeferredPaymentRepository()
                                          .getTotalDeferredPaymentsByMonth(
                                          _selectedDate),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<double> deferredSnapshot) {
                                        double totalDeferredPayments =
                                            deferredSnapshot.data ?? 0.0;
                                        return Text(
                                          '${real.format(totalDeferredPayments)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
                                      style: const TextStyle(
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
                                      style: const TextStyle(
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
