import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/business/cash_payment_controller.dart';
import 'package:iboss/controllers/business/deferred_payment_controller.dart';
import 'package:iboss/controllers/business/fixed_expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:intl/intl.dart';

class BusinessDash extends StatefulWidget {
  const BusinessDash({super.key});

  @override
  State<BusinessDash> createState() => _BusinessDasState();
}

class _BusinessDasState extends State<BusinessDash> {
  DateTime _selectedDate = DateTime.now();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  double totalCashPayments = 0.0;
  double totalDeferredPayments = 0.0;

  double totalFixedExpenses = 0.0;
  double totalVariableExpense = 0.0;

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
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'RECEITAS'),
              Tab(text: 'DESPESAS'),
              Tab(text: 'SALDO'),
            ],
            indicatorColor: Color(0xFF5CE1E6),
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
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: StreamBuilder<double>(
                        stream: CashPaymentController()
                            .getTotalCashPaymentsByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> cashSnapshot) {
                          double totalCashPayments = cashSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: DeferredPaymentController()
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
                      height: 40,
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
                              stream: CashPaymentController()
                                  .getTotalCashPaymentsByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> cashSnapshot) {
                                double totalCashPayments =
                                    cashSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalCashPayments),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
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
                              stream: DeferredPaymentController()
                                  .getTotalDeferredPaymentsByMonth(
                                      _selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> deferredSnapshot) {
                                double totalDeferredPayments =
                                    deferredSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalDeferredPayments),
                                  style: const TextStyle(
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

                //DASHBOARD DE GASTOS:

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
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: StreamBuilder<double>(
                        stream: FixedExpenseController()
                            .getTotalFixedExpensesByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedExpenses = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableExpenseController()
                                .getTotalVariableExpensesByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableExpenses =
                                  variableSnapshot.data ?? 0.0;
                              double total =
                                  totalFixedExpenses + totalVariableExpenses;
                              return total > 0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.yellow,
                                                value: totalVariableExpenses,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalFixedExpenses,
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
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Fixos',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: FixedExpenseController()
                                  .getTotalFixedExpensesByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> fixedSnapshot) {
                                double totalFixedExpenses =
                                    fixedSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalFixedExpenses),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 70),
                        Column(
                          children: [
                            const Text(
                              'Variáveis',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: VariableExpenseController()
                                  .getTotalVariableExpensesByMonth(
                                      _selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> variableSnapshot) {
                                double totalVariableExpenses =
                                    variableSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalVariableExpenses),
                                  style: const TextStyle(
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
                      height: 20,
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: StreamBuilder<double>(
                        stream: FixedExpenseController()
                            .getTotalFixedExpensesByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedExpenses = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableExpenseController()
                                .getTotalVariableExpensesByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableExpenses =
                                  variableSnapshot.data ?? 0.0;
                              double totalExpense =
                                  totalFixedExpenses + totalVariableExpenses;
                              return StreamBuilder<double>(
                                stream: CashPaymentController()
                                    .getTotalCashPaymentsByMonth(_selectedDate),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> cashSnapshot) {
                                  double totalCashPayments =
                                      cashSnapshot.data ?? 0.0;
                                  return totalExpense + totalCashPayments > 0
                                      ? Stack(
                                          children: [
                                            PieChart(
                                              PieChartData(
                                                sections: [
                                                  PieChartSectionData(
                                                    showTitle: false,
                                                    color: Colors.yellow,
                                                    value: totalExpense,
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
                                                        'Saldo',
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        real.format(
                                                            totalCashPayments -
                                                                totalExpense),
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
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
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
                              stream: CashPaymentController()
                                  .getTotalCashPaymentsByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> cashSnapshot) {
                                double totalCashPayments =
                                    cashSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalCashPayments),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 70),
                        Column(
                          children: [
                            const Text(
                              'Despesas',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: FixedExpenseController()
                                  .getTotalFixedExpensesByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> fixedSnapshot) {
                                double totalFixedExpenses =
                                    fixedSnapshot.data ?? 0.0;
                                return StreamBuilder<double>(
                                  stream: VariableExpenseController()
                                      .getTotalVariableExpensesByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> variableSnapshot) {
                                    double totalVariableExpenses =
                                        variableSnapshot.data ?? 0.0;
                                    return Text(
                                      real.format(totalFixedExpenses +
                                          totalVariableExpenses),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.yellow,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
