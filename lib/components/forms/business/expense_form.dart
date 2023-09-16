import 'package:flutter/material.dart';
import 'package:iboss/components/snackbar/show_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business/fixed_expense.dart';
import '../../../models/business/variable_expense.dart';
import '../../../repositories/business/fixed_expense_repository.dart';
import '../../../repositories/business/variable_expense_repository.dart';

class NewExpenseDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogoNewExpense();
      },
    );
  }
}

class _DialogoNewExpense extends StatefulWidget {
  @override
  __DialogoNovaReceitaState createState() => __DialogoNovaReceitaState();
}

class __DialogoNovaReceitaState extends State<_DialogoNewExpense> {
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String invoicingId = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                    if (value.length > 80) {
                      return "Descrição muito longa";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira um valor";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(color: Colors.white),
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
                'É uma despesa fixa ou variável?',
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
                          FixedExpenseRepository fixed, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FixedExpense fixedExpense = FixedExpense(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );
                                await fixed.addExpenseToFirestore(fixedExpense);
                                showSnackbar(context: context,isError: false, menssager: "Despesa adicionada");
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            child: const Text(
                              'Fixa',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer<VariableExpenseRepository>(
                      builder: (BuildContext context,
                          VariableExpenseRepository variable, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                VariableExpense variableExpense = VariableExpense(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );

                                await variable.addExpenseToFirestore(variableExpense);
                                showSnackbar(context: context,isError: false, menssager: "Despesa adicionada");

                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                            ),
                            child: const Text(
                              'Variável',
                              style: TextStyle(
                                fontSize: 16,
                              ),
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
    );
  }
}
