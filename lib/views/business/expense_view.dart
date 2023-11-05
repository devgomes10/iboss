import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/expense_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/business/expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/business/expense_model.dart';
import '../../models/business/variable_expense.dart';

class ExpenseView extends StatefulWidget {
  const ExpenseView({super.key});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  String invoicingId = const Uuid().v1();
  StreamSubscription<List<ExpenseModel>>? expenseStreamSubscription;

  @override
  void initState() {
    super.initState();
    expenseStreamSubscription =
        ExpenseController().getExpensesByMonth(_selectedDate).listen((data) {});
  }

  @override
  void dispose() {
    expenseStreamSubscription?.cancel();
    super.dispose();
  }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Despesas'),
      ),
      floatingActionButton: SingleChildScrollView(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseForm(),
              ),
            );
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
            child: StreamBuilder<List<ExpenseModel>>(
              stream: ExpenseController().getExpensesByMonth(_selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ExpenseModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar as despesas'),
                  );
                }
                final expenses = snapshot.data;
                if (expenses == null || expenses.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma despesa disponível'),
                  );
                }
                return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    ExpenseModel model = expenses[i];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExpenseForm(
                                      model: model,
                                    )));
                      },
                      leading: const FaIcon(
                        FontAwesomeIcons.arrowTrendDown,
                        color: Colors.red,
                      ),
                      title: Text(
                        expenses[i].description,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        real.format(expenses[i].value),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: FaIcon(
                        FontAwesomeIcons.circle,
                        color: Colors.yellow,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                  itemCount: expenses.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// showConfirmation(
//     context: context,
//     title:
//     "Deseja mesmo remover essa despesa fixa?",
//     onPressed: () {
//       final expenseId = fixedExpenses[i].id;
//       FixedExpenseController()
//           .removeExpenseFromFirestore(
//           expenseId);
//     },
//     messegerSnack: "Despesa removida",
//     isError: false);
