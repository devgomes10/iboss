import 'package:flutter/material.dart';
import 'package:iboss/models/cash_payment.dart';
import 'package:iboss/models/deferred_payment.dart';
import 'package:iboss/repositories/cash_payment_repository.dart';
import 'package:iboss/repositories/deferred_payment_repository.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {

  final currentMonth = DateFormat.MMM('pt_BR').format(DateTime.now());
  final date = DateFormat('dd/MM/yyyy', 'pt_BR').format(DateTime.now());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<DeferredPayment> wasPaid = [];

  void add(DeferredPayment paid) {
    wasPaid.add(paid);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receitas - $currentMonth'),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Informação sobre a receita'),
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
                text: 'Pagamento à Vista',
              ),
              Tab(
                text: 'Pagamento a Prazo',
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
                              Consumer<CashPaymentRepository>(
                                builder: (BuildContext context,
                                    CashPaymentRepository inCash,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      inCash.add(CashPayment(
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
                              Consumer<DeferredPaymentRepository>(
                                builder: (BuildContext context,
                                    DeferredPaymentRepository inTerm,
                                    Widget? widget) {
                                  return TextButton(
                                    onPressed: () async {
                                      inTerm.add(DeferredPayment(
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
            
            // Consumer<CashPaymentRepository>(builder: (BuildContext context,
            //     CashPaymentRepository inCash, Widget? widget) {
            //   return ListView.separated(
            //       itemBuilder: (BuildContext context, int i) {
            //         return ListTile(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(Radius.circular(12)),
            //             ),
            //             leading: Icon(Icons.trending_up),
            //             title: Text(inCash.cashPayments[i].description),
            //             subtitle: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(real.format(inCash.cashPayments[i].value)),
            //                 Text(inCash.cashPayments[i].date.toString()),
            //               ],
            //             ),
            //             trailing: IconButton(
            //                 onPressed: () {
            //                   showDialog(context: context, builder: (BuildContext context) => AlertDialog(
            //                       scrollable: true,
            //                       title: const Text('Deseja mesmo exluir este pagamento?'),
            //                       content: SingleChildScrollView(
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: Row(
            //                             crossAxisAlignment: CrossAxisAlignment.center,
            //                             mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                             children: [
            //                               TextButton(onPressed: () {
            //                                 Navigator.pop(context);
            //                               }, child: Text('Não')),
            //                               TextButton(onPressed: () {
            //                                 inCash.remove(i);
            //                                 Navigator.pop(context);
            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(
            //                                   const SnackBar(
            //                                     content: Text(
            //                                         'Pagamento deletado'),
            //                                   ),
            //                                 );
            //                               }, child: Text('Exluir')),
            //                             ],
            //                           ),
            //                         ),
            //                       )
            //                   ),);
            //                 }, icon: Icon(Icons.delete)));
            //       },
            //       separatorBuilder: (_, __) => const Divider(),
            //       padding: const EdgeInsets.all(22),
            //       itemCount: inCash.cashPayments.length);
            // }),
            Consumer<DeferredPaymentRepository>(builder: (BuildContext context,
                DeferredPaymentRepository inTerm, Widget? widget) {
              return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        leading: Icon(Icons.trending_up),
                        title: Text(inTerm.deferredPayments[i].description),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(real.format(inTerm.deferredPayments[i].value)),
                            Text(inTerm.deferredPayments[i].date)
                          ],
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                        scrollable: true,
                                        title: const Text('Você realmente recebeu o dinheiro?'),
                                        content: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(onPressed: () {
                                                  Navigator.pop(context);
                                                }, child: Text('Não')),
                                                TextButton(onPressed: () {
                                                  inTerm.remove(i);
                                                  wasPaid.add(DeferredPayment(
                                                      description:
                                                      descriptionController.text,
                                                      value: double.parse(
                                                          valueController.text),
                                                      date: date));
                                                  print(wasPaid.length);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Pagamento Recebido'),
                                                    ),
                                                  );
                                                }, child: Text('Sim')),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),);
                                  }, icon: Icon(Icons.done)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                        scrollable: true,
                                        title: const Text('Deseja mesmo exluir este pagamento?'),
                                        content: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(onPressed: () {
                                                  Navigator.pop(context);
                                                }, child: Text('Não')),
                                                TextButton(onPressed: () {
                                                  inTerm.remove(i);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Pagamento deletado'),
                                                    ),
                                                  );
                                                }, child: Text('Exluir')),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),);
                                  }, icon: Icon(Icons.delete)),
                            ],
                          ),
                        ));
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  padding: const EdgeInsets.all(16),
                  itemCount: inTerm.deferredPayments.length);
            },),
          ],
        ),
      ),
    );
  }
}
