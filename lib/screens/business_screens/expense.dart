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
    
    final currentMonth = DateFormat.MMM().format(DateTime.now());
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    TextEditingController descriptionController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gastos - $currentMonth'
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
                    return ListTile(
                      leading: Icon(Icons.trending_down),
                      title: Text(fixed.fixedExpenses[i].description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(real.format(fixed.fixedExpenses[i].value)),
                          Text(fixed.fixedExpenses[i].date.toString()),
                        ],
                      ),
                      trailing: IconButton(onPressed: () {
                        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            title: const Text('Deseja mesmo exluir este gasto?'),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: Text('Não')),
                                    TextButton(onPressed: () {
                                      fixed.remove(i);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Gasto deletado'),
                                        ),
                                      );
                                    }, child: Text('Exluir')),
                                  ],
                                ),
                              ),
                            )
                        ),);
                      }, icon: Icon(Icons.delete),),
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
                    return ListTile(
                      leading: Icon(Icons.trending_down),
                      title: Text(variable.variableExpenses[i].description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(real.format(variable.variableExpenses[i].value)),
                          Text(variable.variableExpenses[i].date.toString()),
                        ],
                      ),
                      trailing: IconButton(onPressed: () {
                        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            title: const Text('Deseja mesmo exluir este gasto?'),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: Text('Não')),
                                    TextButton(onPressed: () {
                                      variable.remove(i);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Gasto deletado'),
                                        ),
                                      );
                                    }, child: Text('Exluir')),
                                  ],
                                ),
                              ),
                            )
                        ),);
                      }, icon: Icon(Icons.delete)),
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
