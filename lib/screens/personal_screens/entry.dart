import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  DateTime _selectedDate = DateTime.now();

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
    final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
    TextEditingController descriptionController = TextEditingController();
    TextEditingController valueController = TextEditingController();
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'Entradas',
          ),
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
                  Consumer<FixedEntryRepository>(builder: (BuildContext context,
                      FixedEntryRepository fixed, Widget? widget) {
                    return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: const Icon(Icons.trending_up),
                            title: Text(fixed.fixedEntry[i].description),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(real.format(fixed.fixedEntry[i].value)),
                                Text(fixed.fixedEntry[i].date.toString()),
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
                                                'Deseja mesmo exluir esta entrada?'),
                                            content: SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Não')),
                                                    TextButton(
                                                        onPressed: () {
                                                          fixed.remove(i);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Entrada deletada'),
                                                            ),
                                                          );
                                                        },
                                                        child: const Text(
                                                            'Exluir')),
                                                  ],
                                                ),
                                              ),
                                            )),
                                  );
                                },
                                icon: const Icon(Icons.delete)),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
                        padding: const EdgeInsets.all(16),
                        itemCount: fixed.fixedEntry.length);
                  }),
                  Consumer<VariableEntryRepository>(
                    builder: (BuildContext context,
                        VariableEntryRepository variable, Widget? widget) {
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              leading: const Icon(Icons.trending_up),
                              title:
                                  Text(variable.variableEntry[i].description),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(real
                                      .format(variable.variableEntry[i].value)),
                                  Text(variable.variableEntry[i].date
                                      .toString()),
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
                                                  'Deseja mesmo exluir esta entrada?'),
                                              content: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Não')),
                                                      TextButton(
                                                          onPressed: () {
                                                            variable.remove(i);
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                    'Entrada deletada'),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                              'Exluir')),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
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
          ],
        ),
      ),
    );
  }
}
