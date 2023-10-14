import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/repositories/personal/fixed_entry_repository.dart';
import 'package:iboss/repositories/personal/fixed_outflow_repository.dart';
import 'package:iboss/repositories/personal/variable_entry_repository.dart';
import 'package:iboss/repositories/personal/variable_outflow_repository.dart';
import 'package:intl/intl.dart';

class PersonalDash extends StatefulWidget {
  const PersonalDash({super.key});

  @override
  State<PersonalDash> createState() => _PersonalDashState();
}

class _PersonalDashState extends State<PersonalDash> {
  DateTime _selectedDate = DateTime.now();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

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
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'RENDA'),
              Tab(text: 'GASTOS'),
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
                        stream: FixedEntryRepository()
                            .getTotalFixedEntryByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedEntry = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableEntryRepository()
                                .getTotalVariableEntryByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableEntry =
                                  variableSnapshot.data ?? 0.0;
                              double total =
                                  totalFixedEntry + totalVariableEntry;
                              return total > 0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.yellow,
                                                value: totalVariableEntry,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalFixedEntry,
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
                              'Fixa',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: FixedEntryRepository()
                                  .getTotalFixedEntryByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> fixedSnapshot) {
                                double totalFixedEntry =
                                    fixedSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalFixedEntry),
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
                              'Variaveis',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: VariableEntryRepository()
                                  .getTotalVariableEntryByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> variableSnapshot) {
                                double totalVariableEntry =
                                    variableSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalVariableEntry),
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
                        stream: FixedOutflowRepository()
                            .getTotalFixedOutflowByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedOutflow = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableOutflowRepository()
                                .getTotalVariableOutflowByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableOutflow =
                                  variableSnapshot.data ?? 0.0;
                              double total =
                                  totalFixedOutflow + totalVariableOutflow;
                              return total > 0
                                  ? Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.yellow,
                                                value: totalVariableOutflow,
                                              ),
                                              PieChartSectionData(
                                                showTitle: false,
                                                color: Colors.green,
                                                value: totalFixedOutflow,
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
                              stream: FixedOutflowRepository()
                                  .getTotalFixedOutflowByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> fixedSnapshot) {
                                double totalFixedOutflow =
                                    fixedSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalFixedOutflow),
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
                              stream: VariableOutflowRepository()
                                  .getTotalVariableOutflowByMonth(
                                      _selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> variableSnapshot) {
                                double totalVariableOutflow =
                                    variableSnapshot.data ?? 0.0;
                                return Text(
                                  real.format(totalVariableOutflow),
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
                        stream: FixedOutflowRepository()
                            .getTotalFixedOutflowByMonth(_selectedDate),
                        builder: (BuildContext context,
                            AsyncSnapshot<double> fixedSnapshot) {
                          double totalFixedOutflow = fixedSnapshot.data ?? 0.0;
                          return StreamBuilder<double>(
                            stream: VariableOutflowRepository()
                                .getTotalVariableOutflowByMonth(_selectedDate),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> variableSnapshot) {
                              double totalVariableOutflow =
                                  variableSnapshot.data ?? 0.0;
                              double totalOutflow =
                                  totalFixedOutflow + totalVariableOutflow;
                              return StreamBuilder<double>(
                                stream: FixedEntryRepository()
                                    .getTotalFixedEntryByMonth(_selectedDate),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> fixedSnapshot) {
                                  double totalFixedEntry =
                                      fixedSnapshot.data ?? 0.0;
                                  return StreamBuilder<double>(
                                    stream: VariableEntryRepository()
                                        .getTotalVariableEntryByMonth(
                                            _selectedDate),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<double>
                                            variableSnapshot) {
                                      double totalVariableEntry =
                                          variableSnapshot.data ?? 0.0;
                                      double totalEntry =
                                          totalFixedEntry + totalVariableEntry;
                                      return totalOutflow + totalEntry > 0
                                          ? Stack(
                                              children: [
                                                PieChart(
                                                  PieChartData(
                                                    sections: [
                                                      PieChartSectionData(
                                                        showTitle: false,
                                                        color: Colors.green,
                                                        value: totalEntry,
                                                      ),
                                                      PieChartSectionData(
                                                        showTitle: false,
                                                        color: Colors.yellow,
                                                        value: totalOutflow,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Center(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const Text(
                                                            'Saldo',
                                                            style: TextStyle(
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            real.format(
                                                                totalEntry -
                                                                    totalOutflow),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                              'Renda',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                                stream: FixedEntryRepository()
                                    .getTotalFixedEntryByMonth(_selectedDate),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> fixedSnapshot) {
                                  double totalFixedEntry =
                                      fixedSnapshot.data ?? 0.0;
                                  return StreamBuilder<double>(
                                    stream: VariableEntryRepository()
                                        .getTotalVariableEntryByMonth(
                                            _selectedDate),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<double>
                                            variableSnapshot) {
                                      double totalVariableEntry =
                                          variableSnapshot.data ?? 0.0;
                                      double totalEntry =
                                          totalFixedEntry + totalVariableEntry;
                                      return Text(
                                        real.format(totalEntry),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(width: 70),
                        Column(
                          children: [
                            const Text(
                              'Gastos',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StreamBuilder<double>(
                              stream: FixedOutflowRepository()
                                  .getTotalFixedOutflowByMonth(_selectedDate),
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> fixedSnapshot) {
                                double totalFixedOutflow =
                                    fixedSnapshot.data ?? 0.0;
                                return StreamBuilder<double>(
                                  stream: VariableOutflowRepository()
                                      .getTotalVariableOutflowByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> variableSnapshot) {
                                    double totalVariableOutflow =
                                        variableSnapshot.data ?? 0.0;
                                    double totalOutflow = totalFixedOutflow +
                                        totalVariableOutflow;
                                    return Text(
                                      real.format(totalOutflow),
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
