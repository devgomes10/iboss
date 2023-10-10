import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/personal/outflow_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/personal/fixed_outflow.dart';
import '../../models/personal/variable_outflow.dart';
import '../../repositories/personal/fixed_outflow_repository.dart';
import '../../repositories/personal/variable_outflow_repository.dart';

class Outflow extends StatefulWidget {
  const Outflow({super.key});

  @override
  State<Outflow> createState() => _OutflowState();
}

class _OutflowState extends State<Outflow> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  String invoicingId = const Uuid().v1();

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
          title: const Text('Gastos'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'FIXOS',
              ),
              Tab(
                text: 'VARIÁVEIS',
              ),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewOutflowBottomSheet.show(context);
          },
          backgroundColor: Colors.red,
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
                  StreamBuilder<List<FixedOutflow>>(
                    stream: FixedOutflowRepository()
                        .getFixedOutflowByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FixedOutflow>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar os gastos fixos'),
                        );
                      }
                      final fixedOutflows = snapshot.data;
                      if (fixedOutflows == null || fixedOutflows.isEmpty) {
                        return const Center(
                            child: Text('Nenhum gasto disponível.'));
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          FixedOutflow model1 = fixedOutflows[i];
                          return ListTile(
                            onTap: () {
                              NewOutflowBottomSheet.show(context, model1: model1);
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              fixedOutflows[i].description,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(
                                    fixedOutflows[i].value,
                                  ),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(fixedOutflows[i].date),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmation(
                                    context: context,
                                    title:
                                        "Deseja mesmo remover esse gasto fixo?",
                                    onPressed: () {
                                      final fixedId = fixedOutflows[i].id;
                                      FixedOutflowRepository()
                                          .removeOutflowFromFirestore(fixedId);
                                    },
                                    messegerSnack: "Gasto removido",
                                    isError: false);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                              ),
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
                        itemCount: fixedOutflows.length,
                      );
                    },
                  ),
                  StreamBuilder<List<VariableOutflow>>(
                    stream: VariableOutflowRepository()
                        .getVariableOutflowByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableOutflow>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar os gastos variáveis'),
                        );
                      }
                      final variableOutflow = snapshot.data;
                      if (variableOutflow == null || variableOutflow.isEmpty) {
                        return const Center(
                            child: Text('Nenhum gasto disponível.'));
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          VariableOutflow model2 = variableOutflow[i];
                          return ListTile(
                            onTap: () {
                              NewOutflowBottomSheet.show(context, model2: model2);
                            },
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              variableOutflow[i].description,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(variableOutflow[i].value),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy")
                                      .format(variableOutflow[i].date),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmation(
                                    context: context,
                                    title:
                                        "Deseja mesmo remover esse gasto variável?",
                                    onPressed: () {
                                      final variableId = variableOutflow[i].id;
                                      VariableOutflowRepository()
                                          .removeOutflowFromFirestore(
                                              variableId);
                                    },
                                    messegerSnack: "Gasto removido",
                                    isError: false);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                              ),
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
                        itemCount: variableOutflow.length,
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
