import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:iboss/controllers/business/deferred_payment_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/business/revenue_model.dart';
import '../../models/business/deferred_payment.dart';

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
  bool teste = false;
  StreamSubscription<List<RevenueModel>>? revenueStreamSubscription;
  StreamSubscription<List<DeferredPayment>>? deferredPaymentsStreamSubscription;

  @override
  void initState() {
    super.initState();

    // Registrar a inscrição no stream de receitas
    revenueStreamSubscription = RevenueController()
        .getRevenueByMonth(_selectedDate)
        .listen((data) {
      // Atualizar o estado do widget com os dados
    });

    // Registrar a inscrição no stream de pagamentos pendentes
    deferredPaymentsStreamSubscription = DeferredPaymentController()
        .getDeferredPaymentsByMonth(_selectedDate)
        .listen((data) {
      // Atualizar o estado do widget com os dados
    });
  }

  @override
  void dispose() {
    // Cancelar inscrição no stream de receitas quando a tela for descartada
    revenueStreamSubscription?.cancel();

    // Cancelar inscrição no stream de pagamentos pendentes quando a tela for descartada
    deferredPaymentsStreamSubscription?.cancel();

    super.dispose();
  }


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
          title: const Text('Receitas'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'RECEBIDOS',
              ),
              Tab(
                text: 'PENDENTES',
              ),
            ],
            indicatorColor: Colors.green,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RevenueForm()));
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
                  StreamBuilder<List<RevenueModel>>(
                    stream: RevenueController()
                        .getRevenueByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<RevenueModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child:
                              Text('Erro ao carregar os pagamentos recebidos'),
                        );
                      }
                      final cashPayments = snapshot.data;
                      if (cashPayments == null || cashPayments.isEmpty) {
                        return const Center(
                            child: Text('Nenhum pagamento disponível.'));
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          RevenueModel model1 = cashPayments[i];
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RevenueForm(model1: model1,)));
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                                  real.format(
                                    cashPayments[i].value,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(cashPayments[i].dateNow),
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showConfirmation(
                                    context: context,
                                    title:
                                        "Deseja mesmo remover esse pagamento recebido?",
                                    onPressed: () {
                                      final paymentId = cashPayments[i].id;
                                      RevenueController()
                                          .removeRevenueFromFirestore(
                                              paymentId);
                                    },
                                    messegerSnack: "Pagamento removido",
                                    isError: false);
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
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 16,
                          bottom: 80,
                          right: 16,
                        ),
                        itemCount: cashPayments.length,
                      );
                    },
                  ),
                  StreamBuilder<List<DeferredPayment>>(
                    stream: DeferredPaymentController()
                        .getDeferredPaymentsByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DeferredPayment>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child:
                              Text('Erro ao carregar os pagamentos pendentes'),
                        );
                      }
                      final deferredPayments = snapshot.data;
                      if (deferredPayments == null ||
                          deferredPayments.isEmpty) {
                        return const Center(
                            child: Text('Nenhum pagamento disponível.'));
                      }
                      return ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          DeferredPayment model2 = deferredPayments[i];
                          return ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RevenueForm(model2: model2,)));
                            },
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
                                  Consumer<RevenueController>(
                                    builder: (BuildContext context,
                                        RevenueController inCash,
                                        Widget? widget) {
                                      return IconButton(
                                        onPressed: () {
                                          showConfirmation(
                                              context: context,
                                              title:
                                                  "Você recebeu esse pagamento?",
                                              onPressed: () async {
                                                final paymentId =
                                                    deferredPayments[i].id;
                                                final description =
                                                    deferredPayments[i]
                                                        .description;
                                                final value =
                                                    deferredPayments[i].value;
                                                final date =
                                                    deferredPayments[i].date;
                                                RevenueModel received =
                                                    RevenueModel(
                                                        description:
                                                            description,
                                                        value: value,
                                                        dateNow: date,
                                                        id: paymentId,
                                                      isReceived: teste,
                                                      isRepeat: teste,
                                                      receiptDate: date,
                                                      );
                                                await inCash
                                                    .addRevenueToFirestore(
                                                        received);
                                                DeferredPaymentController()
                                                    .removePaymentFromFirestore(
                                                        paymentId);
                                              },
                                              messegerSnack:
                                                  "Pagamento recebido",
                                              isError: false);
                                        },
                                        icon: const FaIcon(
                                          FontAwesomeIcons.check,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showConfirmation(
                                          context: context,
                                          title:
                                              "Deseja mesmo remover esse pagamento pendente?",
                                          onPressed: () {
                                            final paymentId =
                                                deferredPayments[i].id;
                                            DeferredPaymentController()
                                                .removePaymentFromFirestore(
                                                    paymentId);
                                          },
                                          messegerSnack: "Pagamento removido",
                                          isError: false);
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
                        padding: const EdgeInsets.only(
                          top: 14,
                          left: 16,
                          bottom: 80,
                          right: 16,
                        ),
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
