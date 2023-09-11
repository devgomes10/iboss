import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  FirebaseFirestore db = FirebaseFirestore.instance;
  String invoicingId = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      scrollable: true,
      title: Text(
        'Adicione uma novo gasto',
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
                'É um gasto fixo ou variável',
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
                    Consumer<FixedOutflowRepository>(
                      builder: (BuildContext context,
                          FixedOutflowRepository fixed, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FixedOutflow fixedOuflow = FixedOutflow(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );
                                await fixed.addOutflowToFirestore(fixedOuflow);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Adicionado um novo gasto fixo'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            child: const Text(
                              'Fixo',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer<VariableOutflowRepository>(
                      builder: (BuildContext context,
                          VariableOutflowRepository variable, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                VariableOutflow variableOutflow = VariableOutflow(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );
                                await variable
                                    .addOutflowToFirestore(variableOutflow);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Adicionado um novo gasto variável'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
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
