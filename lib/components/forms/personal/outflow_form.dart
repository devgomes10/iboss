import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/personal/fixed_outflow.dart';
import '../../../models/personal/variable_outflow.dart';
import '../../../repositories/personal/fixed_outflow_repository.dart';
import '../../../repositories/personal/variable_outflow_repository.dart';

class NewOutflowDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogNewOutflow();
      },
    );
  }
}

class _DialogNewOutflow extends StatefulWidget {
  @override
  __DialogoNovaReceitaState createState() => __DialogoNovaReceitaState();
}

class __DialogoNovaReceitaState extends State<_DialogNewOutflow> {
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(scrollable: true,
      title: const Text('Adicione uma nova saída'),
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
                  decoration:
                  const InputDecoration(hintText: 'Descrição'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira um valor";
                    }
                    return null;
                  },
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
                    Consumer<FixedOutflowRepository>(
                      builder: (BuildContext context,
                          FixedOutflowRepository fixed,
                          Widget? widget) {
                        return TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              fixed.add(FixedOutflow(
                                  description:
                                  descriptionController.text,
                                  value: double.parse(
                                      valueController.text),
                                  date: DateTime.now()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                  Text('Criando uma saída fixa'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Fixa'),
                        );
                      },
                    ),
                    Consumer<VariableOutflowRepository>(
                      builder: (BuildContext context,
                          VariableOutflowRepository variable,
                          Widget? widget) {
                        return TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              variable.add(VariableOutflow(
                                  description:
                                  descriptionController.text,
                                  value: double.parse(
                                      valueController.text),
                                  date: DateTime.now()));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Criando uma saída variável'),
                                ),
                              );
                              Navigator.pop(context);
                            }
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
      ],); }}