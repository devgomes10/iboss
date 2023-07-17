import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_entry.dart';
import 'package:iboss/models/variable_entry.dart';
import 'package:iboss/repositories/fixed_entry_repository.dart';
import 'package:iboss/repositories/variable_entry_repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Entradas',
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
                      title: Text('Informação sobre a entrada'),
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
                text: 'Entradas fixas',
              ),
              Tab(
                text: 'Entradas variáveis',
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
                              Consumer<FixedEntryRepository>(
                                builder: (BuildContext context,
                                    FixedEntryRepository fixed,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      fixed.add(FixedEntry(
                                          description:
                                              descriptionController.text,
                                          value: double.parse(
                                              valueController.text),
                                          date: date));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Criando um pagamento à vista'),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('À vista'),
                                  );
                                },
                              ),
                              Consumer<VariableEntryRepository>(
                                builder: (BuildContext context,
                                    VariableEntryRepository variable,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      variable.add(VariableEntry(
                                          description:
                                              descriptionController.text,
                                          value: double.parse(
                                              valueController.text),
                                          date: date));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Criando um pagamento a prazo'),
                                        ),
                                      );
                                      Navigator.pop(context);
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
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            Consumer<FixedEntryRepository>(builder: (BuildContext context,
                FixedEntryRepository fixed, Widget? widget) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: Icon(Icons.trending_up),
                      title: Text(fixed.fixedEntry[i].description),
                      subtitle: Text(fixed.fixedEntry[i].date.toString()),
                      trailing: Text(fixed.fixedEntry[i].value.toString()),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemCount: fixed.fixedEntry.length);
            }),
            Consumer<VariableEntryRepository>(
              builder: (BuildContext context, VariableEntryRepository variable,
                  Widget? widget) {
                return ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        leading: Icon(Icons.trending_up),
                        title: Text(variable.variableEntry[i].description),
                        subtitle: Text(variable.variableEntry[i].date.toString()),
                        trailing: Text(variable.variableEntry[i].value.toString()),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    padding: const EdgeInsets.all(16),
                    itemCount: variable.variableEntry.length);
              },
            ),
          ],
        ),
      ),
    );
  }
}
