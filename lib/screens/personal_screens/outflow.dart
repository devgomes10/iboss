import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:iboss/models/fixed_outflow.dart';
import 'package:iboss/models/variable_outflow.dart';
import 'package:iboss/repositories/fixed_outflow_repository.dart';
import 'package:iboss/repositories/variable_outflow_repository.dart';

class Outflow extends StatefulWidget {
  const Outflow({super.key});

  @override
  State<Outflow> createState() => _OutflowState();
}

class _OutflowState extends State<Outflow> {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Saídas'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Informação sobre a saída'),
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
                text: 'Saídas fixas',
              ),
              Tab(
                text: 'Saídas variáveis',
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
                              if (value.length > 45) {
                                return "Descrição muito longa";
                              }
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
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
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
                  Consumer<FixedOutflowRepository>(
                    builder: (BuildContext context,
                        FixedOutflowRepository fixed, Widget? widget) {
                      final List<FixedOutflow> fixedOutflows =
                      fixed.getFixedOutflowsByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: Icon(Icons.trending_down),
                            title: Text(fixedOutflows[i].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(real.format(fixedOutflows[i].value)),
                                Text(fixedOutflows[i].date.toString()),
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
                                            'Deseja mesmo excluir esta saída?'),
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
                                                  child: const Text('Não'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    fixed.remove(i);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content:
                                                        Text('Saída deletada'),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Excluir'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
                        itemCount: fixedOutflows.length,
                      );
                    },
                  ),
                  Consumer<VariableOutflowRepository>(
                    builder: (BuildContext context,
                        VariableOutflowRepository variable, Widget? widget) {
                      final List<VariableOutflow> variableOutflows =
                      variable.getVariableOutflowsByMonth(_selectedDate);
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: Icon(Icons.trending_down),
                            title: Text(variableOutflows[i].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(real.format(variableOutflows[i].value)),
                                Text(variableOutflows[i].date.toString()),
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
                                            'Deseja mesmo excluir esta saída?'),
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
                                                  child: const Text('Não'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    variable.remove(i);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content:
                                                        Text('Saída deletada'),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text('Excluir'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                );
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
                        itemCount: variableOutflows.length,
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
