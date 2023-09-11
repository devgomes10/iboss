import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business/cash_payment.dart';
import '../../../models/business/deferred_payment.dart';
import '../../../repositories/business/cash_payment_repository.dart';
import '../../../repositories/business/deferred_payment_repository.dart';

class NewRevenueDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogonewRevenue();
      },
    );
  }
}

class _DialogonewRevenue extends StatefulWidget {
  @override
  __DialogoNovaReceitaState createState() => __DialogoNovaReceitaState();
}

class __DialogoNovaReceitaState extends State<_DialogonewRevenue> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String invoicingId = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      scrollable: true,
      title: Text(
        'Adicione um novo pagamento',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "insira uma descrição";
                    }
                    if (value.length > 80) {
                      return "Descrição muito grande";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Insira um valor";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: valueController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
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
              const Text(
                'O pagamento foi recebido?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Consumer<CashPaymentRepository>(
                      builder: (BuildContext context,
                          CashPaymentRepository inCash, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                CashPayment received = CashPayment(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );
                                await inCash.addPaymentToFirestore(received);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Adicionado um novo pagamento recebido'),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            child: const Text(
                              'Recebido',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Consumer<DeferredPaymentRepository>(
                      builder: (BuildContext context,
                          DeferredPaymentRepository inTerm, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                DeferredPayment pending = DeferredPayment(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );
                                await inTerm.addPaymentToFirestore(pending);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Adicionado um novo pagamento pendente',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                            ),
                            child: const Text(
                              'Pendente',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
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
    );
  }
}
