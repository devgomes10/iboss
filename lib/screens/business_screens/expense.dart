import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    final currentMonth = DateFormat.MMM().format(DateTime.now());
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    TextEditingController descriptionController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text('Gastos'),
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
                color: Colors.white,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                scrollable: true,
                title: Text(
                  'Adicione um novo gasto',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return "Insira uma descrição";
                              }
                              if (value.length > 45) {
                                return "Descrição muito longa";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Descrição',
                              labelText: 'Descrição',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Insira um valor";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: valueController,
                            decoration: InputDecoration(
                              hintText: 'Valor',
                              labelText: 'Valor',
                              border: OutlineInputBorder(),
                            ),
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
                        const Text(
                          'Escolha a classificação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                      if (_formKey.currentState!.validate()) {
                                        fixed.add(FixedExpense(
                                          description: descriptionController.text,
                                          value:
                                          double.parse(valueController.text),
                                          date: DateTime
                                              .now(),
                                        ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('Criando um gasto fixo'),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: const Text(
                                      'Fixo',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Consumer<VariableExpenseRepository>(
                                builder: (BuildContext context,
                                    VariableExpenseRepository variable,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        variable.add(VariableExpense(
                                          description: descriptionController.text,
                                          value:
                                          double.parse(valueController.text),
                                          date: DateTime.now(),
                                        ));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                            Text('Criando um gasto variável'),
                                          ),
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.blue,
                                    ),
                                    child: const Text(
                                      'Variável',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
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
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _changeMonth(false),
                  ),
                  Text(
                    DateFormat.yMMMM('pt_BR').format(_selectedDate),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _changeMonth(true),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Consumer<FixedExpenseRepository>(
                    builder: (BuildContext context,
                        FixedExpenseRepository fixed, Widget? widget) {
                      final List<FixedExpense> fixedExpenses =
                      fixed.getFixedExpensesByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: Icon(Icons.trending_down),
                            title: Text(fixedExpenses[i].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(real.format(fixedExpenses[i].value)),
                                Text(fixedExpenses[i].date.toString()),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        scrollable: true,
                                        title: const Text(
                                            'Deseja mesmo excluir este gasto?'),
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
                                                    child: Text('Não')),
                                                TextButton(
                                                    onPressed: () {
                                                      fixed.remove(i);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Gasto deletado'),
                                                        ),
                                                      );
                                                    },
                                                    child: Text('Excluir')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
                        itemCount: fixedExpenses.length,
                      );
                    },
                  ),
                  Consumer<VariableExpenseRepository>(
                    builder: (BuildContext context,
                        VariableExpenseRepository variable, Widget? widget) {
                      final List<VariableExpense> variableExpenses =
                      variable.getVariableExpensesByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: Icon(Icons.trending_down),
                            title: Text(variableExpenses[i].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(real.format(variableExpenses[i].value)),
                                Text(variableExpenses[i].date.toString()),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          scrollable: true,
                                          title: const Text(
                                              'Deseja mesmo excluir este gasto?'),
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
                                                      child: Text('Não')),
                                                  TextButton(
                                                      onPressed: () {
                                                        variable.remove(i);
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Gasto deletado'),
                                                          ),
                                                        );
                                                      },
                                                      child: Text('Excluir')),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                icon: Icon(Icons.delete)),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
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