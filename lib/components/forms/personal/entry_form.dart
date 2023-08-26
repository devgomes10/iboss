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
      scrollable: true,
      title: const Text('Adicione uma nova entrada'),
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
                  decoration: const InputDecoration(hintText: 'Descrição'),
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
                  decoration: const InputDecoration(hintText: 'Valor'),
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
                    Consumer<FixedEntryRepository>(
                      builder: (BuildContext context,
                          FixedEntryRepository fixed, Widget? widget) {
                        return TextButton(
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
                          child: const Text('À vista'),
                        );
                      },
                    ),
                    Consumer<VariableEntryRepository>(
                      builder: (BuildContext context,
                          VariableEntryRepository variable, Widget? widget) {
                        return TextButton(
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
                          child: const Text('Fiado'),
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
