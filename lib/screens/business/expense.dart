import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/expense_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/components/test.dart';
import 'package:iboss/controllers/business/fixed_expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/business/fixed_expense.dart';
import '../../models/business/variable_expense.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  String invoicingId = const Uuid().v1();

  void _changeMonth(bool increment) {
    setState(
      () {
        if (increment) {
          _selectedDate =
              DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
        } else {
          _selectedDate =
              DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Despesas'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'FIXAS',
              ),
              Tab(
                text: 'VARIÁVEIS',
              ),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        floatingActionButton: SingleChildScrollView(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Test()));
            },
            backgroundColor: Colors.red,
            child: const FaIcon(FontAwesomeIcons.plus),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.caretRight),
                    onPressed: () => _changeMonth(true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<List<FixedExpense>>(
                    stream: FixedExpenseController()
                        .getFixedExpensesByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FixedExpense>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar as despesas fixas'),
                        );
                      }
                      final fixedExpenses = snapshot.data;
                      if (fixedExpenses == null || fixedExpenses.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma despesa disponível.'),
                        );
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          FixedExpense model1 = fixedExpenses[i];
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Test(model1: model1,)));

                            },
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              fixedExpenses[i].description,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(fixedExpenses[i].value),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(fixedExpenses[i].date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmation(
                                    context: context,
                                    title:
                                        "Deseja mesmo remover essa despesa fixa?",
                                    onPressed: () {
                                      final expenseId = fixedExpenses[i].id;
                                      FixedExpenseController()
                                          .removeExpenseFromFirestore(
                                              expenseId);
                                    },
                                    messegerSnack: "Despesa removida",
                                    isError: false);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white),
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 16,
                          bottom: 80,
                          right: 16,
                        ),
                        itemCount: fixedExpenses.length,
                      );
                    },
                  ),
                  StreamBuilder<List<VariableExpense>>(
                    stream: VariableExpenseController()
                        .getVariableExpensesByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableExpense>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar as despesas variáveis'),
                        );
                      }
                      final variableExpenses = snapshot.data;
                      if (variableExpenses == null ||
                          variableExpenses.isEmpty) {
                        return const Center(
                            child: Text('Nenhuma despesa disponível.'));
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          VariableExpense model2 = variableExpenses[i];
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Test(model2: model2,)));

                            },
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              variableExpenses[i].description,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(
                                    variableExpenses[i].value,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(variableExpenses[i].date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmation(
                                    context: context,
                                    title:
                                        "Deseja mesmo remover essa despesa variável?",
                                    onPressed: () {
                                      final expenseId = variableExpenses[i].id;
                                      VariableExpenseController()
                                          .removeExpenseFromFirestore(
                                              expenseId);
                                    },
                                    messegerSnack: "Despesa removida",
                                    isError: false);
                              },
                              icon: const FaIcon(FontAwesomeIcons.trash),
                              color: Colors.red,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white),
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 16,
                          bottom: 80,
                          right: 16,
                        ),
                        itemCount: variableExpenses.length,
                      );
                    },
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
