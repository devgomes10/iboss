import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:iboss/components/show_confirmation.dart';
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
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
            NewRevenueBottomSheet.show(context);
          },
          child: const FaIcon(FontAwesomeIcons.plus),
          backgroundColor: Colors.green,
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
                  StreamBuilder<List<CashPayment>>(
                    stream: CashPaymentRepository()
                        .getCashPaymentsByMonth(_selectedDate),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CashPayment>> snapshot) {
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
                                  real.format(
                                    cashPayments[i].value,
                                  ),
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
                                showConfirmation(
                                    context: context,
                                    title: "Deseja mesmo remover esse pagamento recebido?",
                                    onPressed: () {
                                      final paymentId = cashPayments[i].id;
                                      CashPaymentRepository()
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
                    stream: DeferredPaymentRepository()
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
                                  Consumer<CashPaymentRepository>(
                                    builder: (BuildContext context,
                                        CashPaymentRepository inCash,
                                        Widget? widget) {
                                      return IconButton(
                                        onPressed: () {
                                          showConfirmation(
                                              context: context,
                                              title: "Você recebeu esse pagamento?",
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
                                              },
                                              messegerSnack: "Pagamento recebido",
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
                                      showConfirmation(context: context,
                                          title: "Deseja mesmo remover esse pagamento pendente?",
                                          onPressed: () {
                                            final paymentId =
                                                deferredPayments[i]
                                                    .id;
                                            DeferredPaymentRepository()
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
