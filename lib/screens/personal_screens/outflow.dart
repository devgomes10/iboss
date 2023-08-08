import 'package:flutter/material.dart';
import 'package:iboss/models/fixed_outflow.dart';
import 'package:iboss/models/variable_outflow.dart';
import 'package:iboss/repositories/fixed_outflow_repository.dart';
import 'package:iboss/repositories/variable_outflow_repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Outflow extends StatefulWidget {
  const Outflow({super.key});

  @override
  State<Outflow> createState() => _OutflowState();
}

class _OutflowState extends State<Outflow> {

  final date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'Saídas',
          ),
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
                color: Colors.black,
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
                              Consumer<FixedOutflowRepository>(
                                builder: (BuildContext context,
                                    FixedOutflowRepository fixed,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      fixed.add(FixedOutflow(
                                          description:
                                          descriptionController.text,
                                          value: double.parse(
                                              valueController.text),
                                          date: DateTime.now()));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Criando uma saída fixa'),
                                        ),
                                      );
                                      Navigator.pop(context);
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
        body: TabBarView(
          children: [
            Consumer<FixedOutflowRepository>(builder: (BuildContext context,
                FixedOutflowRepository fixed, Widget? widget) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      leading: Icon(Icons.trending_down),
                      title:  Text(fixed.fixedOutflow[i].description),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(real.format(fixed.fixedOutflow[i].value)),
                          Text(fixed.fixedOutflow[i].date.toString()),
                        ],
                      ),
                      trailing: IconButton(onPressed: () {
                        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            title: const Text('Deseja mesmo exluir esta saída?'),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: const Text('Não')),
                                    TextButton(onPressed: () {
                                      fixed.remove(i);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'saída deletada'),
                                        ),
                                      );
                                    }, child: const Text('Exluir')),
                                  ],
                                ),
                              ),
                            )
                        ),);
                      }, icon: const Icon(Icons.delete)),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemCount: fixed.fixedOutflow.length);
            }),
            Consumer<VariableOutflowRepository>(
              builder: (BuildContext context, VariableOutflowRepository variable,
                  Widget? widget) {
                return ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        leading: Icon(Icons.trending_down),
                        title: Text(variable.variableOutflow[i].description),
                        subtitle:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(real.format(variable.variableOutflow[i].value)),
                            Text(variable.variableOutflow[i].date.toString()),
                          ],
                        ),
                      trailing: IconButton(onPressed: () {
                        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                            scrollable: true,
                            title: const Text('Deseja mesmo exluir esta saída?'),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, child: const Text('Não')),
                                    TextButton(onPressed: () {
                                      variable.remove(i);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'saída deletada'),
                                        ),
                                      );
                                    }, child: const Text('Exluir')),
                                  ],
                                ),
                              ),
                            )
                        ),);
                      }, icon: const Icon(Icons.delete)),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    padding: const EdgeInsets.all(16),
                    itemCount: variable.variableOutflow.length);
              },
            ),
          ],
        ),
      ),
    );
  }
}
