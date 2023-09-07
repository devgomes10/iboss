import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/personal/entry_form.dart';
import 'package:iboss/models/personal/fixed_entry.dart';
import 'package:iboss/models/personal/variable_entry.dart';
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
          backgroundColor: Theme.of(context).colorScheme.primary,
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
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Fixas',
              ),
              Tab(
                text: 'Variáveis',
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
                  StreamBuilder<List<FixedEntry>>(
                      stream: FixedEntryRepository()
                          .getFixedEntryByMonth(_selectedDate),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FixedEntry>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Erro: ${snapshot.error}');
                        }
                        final fixedEntry = snapshot.data;
                        if (fixedEntry == null || fixedEntry.isEmpty) {
                          return const Text('Nenhum pagamento disponível.');
                        }
                        return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                            ),
                            title: Text(
                              fixedEntry[i].description,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(fixedEntry[i].value),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(fixedEntry[i].date),
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
                                      title: Text(
                                        'Deseja exluir esta entrada fixa?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
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
                                                child: const Text(
                                                  'NÃO',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final fixedId = fixedEntry[i].id;
                                                  FixedEntryRepository().removeEntryFromFirestore(fixedId);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Entrada deletada'),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'EXCLUIR',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
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
                        itemCount: fixedEntry.length);
                  }),
                  StreamBuilder<List<VariableEntry>>(
                    stream: VariableEntryRepository()
                        .getVariableEntryByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableEntry>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      final variableEntry = snapshot.data;
                      if (variableEntry == null || variableEntry.isEmpty) {
                        return const Text('Nenhum pagamento disponível.');
                      }
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.arrowTrendUp,
                                color: Colors.green,
                              ),
                              title: Text(
                                variableEntry[i].description,
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    real.format(
                                        variableEntry[i].value),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(variableEntry[i].date),
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
                                      title: Text(
                                        'Deseja exluir esta entrada variável?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
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
                                                child: const Text(
                                                  'NÃO',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final variableId = variableEntry[i].id;
                                                  VariableEntryRepository().removeEntryFromFirestore(variableId);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Entrada deletada'),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'EXCLUIR',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                  ),
                                                ),
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
                          itemCount: variableEntry.length);
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
