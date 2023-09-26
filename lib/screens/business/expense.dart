import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/expense_form.dart';
import 'package:intl/intl.dart';
import '../../models/business/fixed_expense.dart';
import '../../models/business/variable_expense.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';

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
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('Despesas'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'FIXAS',
              ),
              Tab(
                text: 'VARIÁVEIS',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewExpenseBottomSheet.show(context);
          },
          child: const FaIcon(FontAwesomeIcons.plus),
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
                    stream: FixedExpenseRepository()
                        .getFixedExpensesByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FixedExpense>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Erro ao carregar as despesas fixas'),);
                      }
                      final fixedExpenses = snapshot.data;
                      if (fixedExpenses == null || fixedExpenses.isEmpty) {
                        return const Center(child: Text('Nenhuma despesa disponível.'));
                      } return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                      'Deseja mesmo excluir esta despesa fixa?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    content: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'NÃO',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final expenseId = fixedExpenses[i].id;
                                                FixedExpenseRepository().removeExpenseFromFirestore(expenseId);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Despesa deletada'),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'EXCLUIR',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
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
                        padding: const EdgeInsets.only(top: 14, left: 16, bottom: 80, right: 16,),
                        itemCount: fixedExpenses.length,
                      );
                    },
                  ),
                  StreamBuilder<List<VariableExpense>>(
                    stream: VariableExpenseRepository()
                        .getVariableExpensesByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableExpense>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(child: Text('Erro ao carregar as despesas variáveis'),);
                      }
                      final variableExpenses = snapshot.data;
                      if (variableExpenses == null || variableExpenses.isEmpty) {
                        return const Center(child: Text('Nenhuma despesa disponível.'));
                      } return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    scrollable: true,
                                    title: Text(
                                      'Deseja mesmo excluir esta despesa variável?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    content: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'NÃO',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final expenseId = variableExpenses[i].id;
                                                VariableExpenseRepository().removeExpenseFromFirestore(expenseId);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Despesa deletada'),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'EXCLUIR',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const FaIcon(FontAwesomeIcons.trash),
                              color: Colors.red,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white),
                        padding: const EdgeInsets.only(top: 14, left: 16, bottom: 80, right: 16,),
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
