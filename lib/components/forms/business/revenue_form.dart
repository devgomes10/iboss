import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business/cash_payment.dart';
import '../../../models/business/deferred_payment.dart';
import '../../../repositories/business/cash_payment_repository.dart';
import '../../../repositories/business/deferred_payment_repository.dart';
import '../../show_snackbar.dart';

class NewRevenueBottomSheet {
  static void show(BuildContext context, {CashPayment? model1, DeferredPayment? model2}) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return _BottomSheetNewRevenue(model1: model1, model2: model2,);
      },
    );
  }
}

class _BottomSheetNewRevenue extends StatefulWidget {
  final CashPayment? model1;
  final DeferredPayment? model2;

  const _BottomSheetNewRevenue({this.model1, this.model2});

  @override
  __BottomSheetNewRevenueState createState() => __BottomSheetNewRevenueState();
}

class __BottomSheetNewRevenueState extends State<_BottomSheetNewRevenue> {
  bool _isEditing1 = false;
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  bool _isEditing2 = false;

  @override
  void initState() {
    super.initState();
    if (widget.model1 != null) {
      descriptionController.text = widget.model1!.description;
      valueController.text = widget.model1!.value.toString();
      _isEditing1 = true;
    }
    if (widget.model2 != null) {
      descriptionController.text = widget.model2!.description;
      valueController.text = widget.model2!.value.toString();
      _isEditing2 = true;
    }
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    valueFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cashPaymentModel = widget.model1;
    final deferredPaymentModel = widget.model2;
    final titleText =
        _isEditing1 || _isEditing2 ? "Editando pagamento" : "Adicione um novo pagamento";
    final buttonText1 = _isEditing1 ? "Confirmar" : "RECEBIDO";
    final buttonText2 = _isEditing2 ? "Confirmar" : "PENDENTE";
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Insira uma descrição";
                  }
                  if (value.length > 80) {
                    return "Descrição muito grande";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: descriptionController,
                focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                focusNode: valueFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (!_isEditing1 && !_isEditing2)
                const Center(
                  child: Text(
                    'O pagamento já foi recebido?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!_isEditing2)
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

                              if (cashPaymentModel != null) {
                                received.id = cashPaymentModel.id;
                              }

                              await CashPaymentRepository()
                                  .addPaymentToFirestore(received);
                              showSnackbar(
                                  context: context,
                                  isError: false,
                                  menssager: "Pagamento adicionado");
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF5CE1E6),
                          ),
                          child: Text(
                            buttonText1,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  if (!_isEditing1)
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

                                if (deferredPaymentModel != null) {
                                  pending.id = deferredPaymentModel.id;
                                }

                                await DeferredPaymentRepository()
                                    .addPaymentToFirestore(pending);
                                showSnackbar(
                                    context: context,
                                    isError: false,
                                    menssager: "Pagamento adicionado");
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF5CE1E6),
                            ),
                            child: Text(
                              buttonText2,
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
            ],
          ),
        ),
      ),
    );
  }
}
