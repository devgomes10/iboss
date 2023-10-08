import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/dash.dart';
import 'package:intl/intl.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';

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
                Dash(
                  stream1: CashPaymentRepository()
                      .getTotalCashPaymentsByMonth(_selectedDate),
                  stream2: DeferredPaymentRepository()
                      .getTotalDeferredPaymentsByMonth(_selectedDate),
                  string1: "Recebidos",
                  string2: "Pendentes",
                ),
                Dash(
                  stream1: FixedExpenseRepository()
                      .getTotalFixedExpensesByMonth(_selectedDate),
                  stream2: VariableExpenseRepository()
                      .getTotalVariableExpensesByMonth(_selectedDate),
                  string1: "Fixas",
                  string2: "Variáveis",
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
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: StreamBuilder<double>(
                        stream: FixedExpenseRepository()
                            .getTotalFixedExpensesByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedExpenses = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableExpenseRepository()
                                .getTotalVariableExpensesByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableExpenses =
                                  variableSnapshot.data ?? 0.0;
                              double totalExpense =
                                  totalFixedExpenses + totalVariableExpenses;
                              return StreamBuilder<double>(
                                stream: CashPaymentRepository()
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
                              stream: CashPaymentRepository()
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
