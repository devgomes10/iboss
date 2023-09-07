import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/personal/outflow_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
            NewOutflowDialog.show(context);
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
                  StreamBuilder<List<FixedOutflow>>(
                    stream: FixedOutflowRepository()
                        .getFixedOutflowByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FixedOutflow>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      final fixedOutflow = snapshot.data;
                      if (fixedOutflow == null || fixedOutflow.isEmpty) {
                        return const Text('Nenhum pagamento disponível.');
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              fixedOutflow[i].description,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(
                                    fixedOutflow[i].value,
                                  ),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(fixedOutflow[i].date),
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
                                        'Deseja mesmo excluir esta saída fixa?', style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,),
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
                                              child: const Text('NÃO', style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final fixedId = fixedOutflow[i].id;
                                                FixedOutflowRepository().removeOutflowFromFirestore(fixedId);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Saída deletada'),
                                                  ),
                                                );
                                              },
                                              child: const Text('Excluir', style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),),
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
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
                        itemCount: fixedOutflow.length,
                      );
                    },
                  ),
                  StreamBuilder<List<VariableOutflow>>(
                    stream: VariableOutflowRepository()
                        .getVariableOutflowByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<VariableOutflow>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      final variableOutflow = snapshot.data;
                      if (variableOutflow == null || variableOutflow.isEmpty) {
                        return const Text('Nenhum pagamento disponível.');
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                            title: Text(
                              variableOutflow[i].description,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(variableOutflow[i].value),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  DateFormat("dd/MM/yyyy")
                                      .format(variableOutflow[i].date),
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
                                        'Deseja mesmo excluir esta saída variável?', style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,),
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
                                              child: const Text('NÃO', style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final variableId = variableOutflow[i].id;
                                                VariableOutflowRepository().removeOutflowFromFirestore(variableId);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Saída deletada'),
                                                  ),
                                                );
                                              },
                                              child: const Text('EXCLUIR', style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),),
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
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(16),
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
