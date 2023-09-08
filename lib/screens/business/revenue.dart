import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/business/cash_payment.dart';
import '../../models/business/deferred_payment.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';

class Revenue extends StatefulWidget {
  const Revenue({super.key});

  @override
  State<Revenue> createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  DateTime _selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
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
          title: const Text('Faturamento'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Mesada da empresa'),
                      content: Text('... '),
                    );
                  },
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.circleInfo,
                color: Colors.yellow,
              ),
            ),
          ],
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Recebidos',
              ),
              Tab(
                text: 'Pendentes',
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewRevenueDialog.show(context);
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
                  StreamBuilder<List<CashPayment>>(
                    stream: CashPaymentRepository()
                        .getCashPaymentsByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CashPayment>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }
                      final cashPayments = snapshot.data;
                      if (cashPayments == null || cashPayments.isEmpty) {
                        return const Text('Nenhum pagamento disponível.');
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          print("deve adicionar agora o mesmo $invoicingId");
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                            ),
                            title: Text(
                              cashPayments[i].description,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(cashPayments[i].value),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(cashPayments[i].date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
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
                                      'Deseja mesmo excluir este pagamento recebido?',
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
                                                final paymentId =
                                                    cashPayments[i].id;
                                                CashPaymentRepository()
                                                    .removePaymentFromFirestore(
                                                        paymentId);
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Pagamento deletado'),
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
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white),
                        padding: const EdgeInsets.all(22),
                        itemCount: cashPayments.length,
                      );
                    },
                  ),
                  StreamBuilder<List<DeferredPayment>>(
                    stream: DeferredPaymentRepository()
                        .getDeferredPaymentsByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DeferredPayment>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      }

                      final deferredPayments = snapshot.data;

                      if (deferredPayments == null ||
                          deferredPayments.isEmpty) {
                        return const Text('Nenhum pagamento disponível.');
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            leading: const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                            ),
                            title: Text(
                              deferredPayments[i].description,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  real.format(deferredPayments[i].value),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(deferredPayments[i].date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          scrollable: true,
                                          title: Text(
                                            'Você recebeu o dinheiro?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
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
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'NÃO',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Consumer<
                                                      CashPaymentRepository>(
                                                    builder: (BuildContext
                                                            context,
                                                        CashPaymentRepository
                                                            inCash,
                                                        Widget? widget) {
                                                      return TextButton(
                                                        onPressed: () async {
                                                          final paymentId =
                                                              deferredPayments[
                                                                      i]
                                                                  .id;
                                                          final description =
                                                              deferredPayments[
                                                                      i]
                                                                  .description;
                                                          final value =
                                                              deferredPayments[
                                                                      i]
                                                                  .value;
                                                          final date =
                                                              deferredPayments[
                                                                      i]
                                                                  .date;
                                                          CashPayment received =
                                                              CashPayment(
                                                                  description:
                                                                      description,
                                                                  value: value,
                                                                  date: date,
                                                                  id: paymentId);
                                                          await inCash
                                                              .addPaymentToFirestore(
                                                                  received);
                                                          DeferredPaymentRepository()
                                                              .removePaymentFromFirestore(
                                                                  paymentId);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'Pagamento Recebido'),
                                                            ),
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: TextButton
                                                            .styleFrom(),
                                                        child: const Text(
                                                          'RECEBI',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.check,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          scrollable: true,
                                          title: Text(
                                            'Deseja mesmo excluir este pagamento pendente?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
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
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'NÃO',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final paymentId =
                                                          deferredPayments[i]
                                                              .id;
                                                      DeferredPaymentRepository()
                                                          .removePaymentFromFirestore(
                                                              paymentId);
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Pagamento deletado'),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'EXCLUIR',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white),
                        padding: const EdgeInsets.all(16),
                        itemCount: deferredPayments.length,
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
