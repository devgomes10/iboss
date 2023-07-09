import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_expense.dart';
import 'package:iboss/models/variable_expense.dart';
import 'package:iboss/repositories/fixed_expense_repository.dart';
import 'package:iboss/repositories/variable_expense_repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    TextEditingController descriptionController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Gastos',
          ),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Informação sobre os Gastos'),
                      content: Text('Texto passando as informações'),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.info,
                color: Colors.black,
              ),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Gastos Fixos',
              ),
              Tab(
                text: 'Gastos Variáveis',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                scrollable: true,
                title: const Text('Din Din'),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: descriptionController,
                            decoration:
                            const InputDecoration(hintText: 'Descrição'),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: valueController,
                            decoration:
                            const InputDecoration(hintText: 'Valor'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: Column(
                      children: [
                        const Text('Escolha a classificação'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<FixedExpenseRepository>(
                                builder: (BuildContext context,
                                    FixedExpenseRepository fixed,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      fixed.add(FixedExpense(
                                          description:
                                          descriptionController.text,
                                          value: double.parse(
                                              valueController.text),
                                          date: date));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text('Criando um gasto fixo'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Fixo'),
                                  );
                                },
                              ),
                              Consumer<VariableExpenseRepository>(
                                builder: (BuildContext context,
                                    VariableExpenseRepository variable,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      variable.add(VariableExpense(
                                          description:
                                          descriptionController.text,
                                          value: double.parse(
                                              valueController.text),
                                          date: date));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                          Text('Criando um gasto variável'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Variável'),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            Consumer<FixedExpenseRepository>(builder: (BuildContext context,
                FixedExpenseRepository fixed, Widget? widget) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      child: ListTile(
                        leading: Text(fixed.fixedExpenses[i].description),
                        title: Text(fixed.fixedExpenses[i].value.toString()),
                        trailing: Text(fixed.fixedExpenses[i].date.toString()),
                      ),
                      onDismissed: (direction) {
                        fixed.remove(i);
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemCount: fixed.fixedExpenses.length);
            }),
            Consumer<VariableExpenseRepository>(builder: (BuildContext context,
                VariableExpenseRepository variable, Widget? widget) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      child: ListTile(
                        leading: Text(variable.variableExpenses[i].description),
                        title: Text(variable.variableExpenses[i].value.toString()),
                        trailing: Text(variable.variableExpenses[i].date.toString()),
                      ),
                      onDismissed: (direction) {
                        variable.remove(i);
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemCount: variable.variableExpenses.length);
            }),
          ],
        ),
      ),
    );
  }
}
