import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/personal/entry_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/models/personal/fixed_entry.dart';
import 'package:iboss/models/personal/variable_entry.dart';
import 'package:iboss/repositories/personal/fixed_entry_repository.dart';
import 'package:intl/intl.dart';
import '../../repositories/personal/variable_entry_repository.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  DateTime _selectedDate = DateTime.now();
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Renda',
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'FIXAS',
              ),
              Tab(
                text: 'VARIÁVEIS',
              ),
            ],
            indicatorColor: Colors.green,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewEntryBottomSheet.show(context);
          },
          backgroundColor: Colors.green,
          child: const FaIcon(FontAwesomeIcons.plus),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 6,
            ),
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Erro ao carregar rendas fixas'),
                          );
                        }
                        final fixedEntry = snapshot.data;
                        if (fixedEntry == null || fixedEntry.isEmpty) {
                          return const Center(
                              child: Text('Nenhuma renda disponível.'));
                        }
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int i) {
                              FixedEntry model1 = fixedEntry[i];
                              return ListTile(
                                onTap: () {
                                  NewEntryBottomSheet.show(context, model1: model1);
                                },
                                leading: const FaIcon(
                                  FontAwesomeIcons.arrowTrendUp,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  fixedEntry[i].description,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      real.format(fixedEntry[i].value),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(fixedEntry[i].date),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      showConfirmation(
                                          context: context,
                                          title:
                                              "Deseja mesmo remover essa renda fixa?",
                                          onPressed: () {
                                            final fixedId = fixedEntry[i].id;
                                            FixedEntryRepository()
                                                .removeEntryFromFirestore(
                                                    fixedId);
                                          },
                                          messegerSnack: "Renda removida",
                                          isError: false);
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
                            padding: const EdgeInsets.only(
                              top: 14,
                              left: 16,
                              bottom: 80,
                              right: 16,
                            ),
                            itemCount: fixedEntry.length);
                      }),
                  StreamBuilder<List<VariableEntry>>(
                    stream: VariableEntryRepository()
                        .getVariableEntryByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableEntry>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar rendas variáveis'),
                        );
                      }
                      final variableEntry = snapshot.data;
                      if (variableEntry == null || variableEntry.isEmpty) {
                        return const Center(
                            child: Text('Nenhuma renda disponível.'));
                      }
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int i) {
                            VariableEntry model2 = variableEntry[i];
                            return ListTile(
                              onTap: () {
                                NewEntryBottomSheet.show(context, model2: model2);
                              },
                              leading: const FaIcon(
                                FontAwesomeIcons.arrowTrendUp,
                                color: Colors.green,
                              ),
                              title: Text(
                                variableEntry[i].description,
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    real.format(variableEntry[i].value),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(variableEntry[i].date),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  showConfirmation(
                                      context: context,
                                      title:
                                          "Deseja mesmo remover essa renda variável?",
                                      onPressed: () {
                                        final variableId = variableEntry[i].id;
                                        VariableEntryRepository()
                                            .removeEntryFromFirestore(
                                                variableId);
                                      },
                                      messegerSnack: "Renda removida",
                                      isError: false);
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(
                                color: Colors.white,
                              ),
                          padding: const EdgeInsets.only(
                            top: 14,
                            left: 16,
                            bottom: 80,
                            right: 16,
                          ),
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
