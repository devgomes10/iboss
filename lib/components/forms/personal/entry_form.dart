import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/personal/fixed_entry.dart';
import '../../../models/personal/variable_entry.dart';
import '../../../repositories/personal/fixed_entry_repository.dart';
import '../../../repositories/personal/variable_entry_repository.dart';

class NewEntryDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogoNewEntry();
      },
    );
  }
}

class _DialogoNewEntry extends StatefulWidget {
  @override
  __DialogoNovaReceitaState createState() => __DialogoNovaReceitaState();
}

class __DialogoNovaReceitaState extends State<_DialogoNewEntry> {
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      scrollable: true,
      title: Text(
        'Adicione uma nova entrada',
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
                    hintText: 'Descrição',
                    labelText: 'Insira uma descrição...',
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
                    hintText: 'Valor',
                    labelText: 'Insira o valor...',
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
                    Consumer<FixedEntryRepository>(
                      builder: (BuildContext context,
                          FixedEntryRepository fixed, Widget? widget) {
                        return Container(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                fixed.add(FixedEntry(
                                    description: descriptionController.text,
                                    value: double.parse(valueController.text),
                                    date: DateTime.now()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Criando um pagamento à vista'),
                                  ),
                                );
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
                    Consumer<VariableEntryRepository>(
                      builder: (BuildContext context,
                          VariableEntryRepository variable, Widget? widget) {
                        return Container(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                variable.add(VariableEntry(
                                    description: descriptionController.text,
                                    value: double.parse(valueController.text),
                                    date: DateTime.now()));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Criando um pagamento a prazo'),
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
