import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/business/revenue_model.dart';

class RevenueView extends StatefulWidget {
  const RevenueView({super.key});

  @override
  State<RevenueView> createState() => _RevenueViewState();
}

class _RevenueViewState extends State<RevenueView> {
  DateTime _selectedDate = DateTime.now();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  String invoicingId = const Uuid().v1();
  StreamSubscription<List<RevenueModel>>? revenueStreamSubscription;

  @override
  void initState() {
    super.initState();
    revenueStreamSubscription =
        RevenueController().getRevenueByMonth(_selectedDate).listen((data) {});
  }

  @override
  void dispose() {
    revenueStreamSubscription?.cancel();
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Receitas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/revenueForm");
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
            child: StreamBuilder<List<RevenueModel>>(
              stream: RevenueController().getRevenueByMonth(_selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<RevenueModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar as receitas'),
                  );
                }
                final revenues = snapshot.data;
                if (revenues == null || revenues.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma receita disponível'),
                  );
                }
                return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    RevenueModel model = revenues[i];
                    return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RevenueForm(
                                model: model,
                              ),
                            ),
                          );
                        },
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        leading:
                        (revenues[i].isReceived == true) ?
                        FaIcon(
                          FontAwesomeIcons.arrowTrendUp,
                          color: Colors.green,
                        ) : FaIcon(FontAwesomeIcons.arrowTrendDown),
                        title: Text(
                          revenues[i].description,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              real.format(
                                revenues[i].value,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              " | ${DateFormat.Md("pt_BR").format(revenues[i].receiptDate)}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        trailing: revenues[i].isReceived == true
                            ? FaIcon(
                                FontAwesomeIcons.chevronUp,
                                // color: Colors.lightBlue,
                                size: 20,
                              )
                            : FaIcon(
                                FontAwesomeIcons.minus,
                                // color: Colors.yellow,
                                size: 20,
                              ));
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                  itemCount: revenues.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// showConfirmation(
//     context: context,
//     title:
//         "Deseja mesmo remover esse pagamento recebido?",
//     onPressed: () {
//       final paymentId = cashPayments[i].id;
//       RevenueController()
//           .removeRevenueFromFirestore(paymentId);
//     },
//     messegerSnack: "Pagamento removido",
//     isError: false);
