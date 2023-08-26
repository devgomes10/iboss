import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/personal/entry_form.dart';
import 'package:iboss/repositories/personal/fixed_entry_repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../repositories/personal/variable_entry_repository.dart';

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
                icon: const FaIcon(FontAwesomeIcons.circleInfo))
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
            NewEntryDialog.show(context);
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
                    icon: const FaIcon(FontAwesomeIcons.caretLeft),
                    onPressed: () => _changeMonth(false),
                  ),
                  Text(
                    DateFormat.yMMMM('pt_BR').format(_selectedDate),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.caretRight),
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
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                            ),
                            title: Text(
                              fixed.fixedEntry[i].description,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(fixed.fixedEntry[i].value),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(fixed.fixedEntry[i].date),
                                  style: TextStyle(fontSize: 16),
                                ),
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
                                                  child: const Text('Não')),
                                              TextButton(
                                                onPressed: () {
                                                  fixed.remove(i);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Entrada deletada'),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Exluir'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                )),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(
                              color: Colors.white,
                            ),
                        padding: const EdgeInsets.all(16),
                        itemCount: fixed.fixedEntry.length);
                  }),
                  Consumer<VariableEntryRepository>(
                    builder: (BuildContext context,
                        VariableEntryRepository variable, Widget? widget) {
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.arrowTrendUp,
                                color: Colors.green,
                              ),
                              title: Text(
                                variable.variableEntry[i].description,
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    real.format(
                                        variable.variableEntry[i].value),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(variable.variableEntry[i].date),
                                    style: TextStyle(fontSize: 16),
                                  ),
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
                                                  child: const Text('Não')),
                                              TextButton(
                                                onPressed: () {
                                                  variable.remove(i);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Entrada deletada'),
                                                    ),
                                                  );
                                                },
                                                child: const Text('Exluir'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(
                                color: Colors.white,
                              ),
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
