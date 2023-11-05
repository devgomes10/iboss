import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/controllers/business/catalog_controller.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:iboss/models/business/revenue_model.dart';
import 'package:iboss/views/business/catalog_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RevenueForm extends StatefulWidget {
  final RevenueModel? model;

  const RevenueForm({Key? key, this.model}) : super(key: key);

  @override
  State<RevenueForm> createState() => _RevenueFormState();
}

class _RevenueFormState extends State<RevenueForm> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController datePickerController = TextEditingController();
  final descriptionController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueController = TextEditingController();
  final valueFocusNode = FocusNode();
  bool isRepeat = false;
  bool isReceived = false;
  DateTime selectedPicker = DateTime.now();
  final ptBr = const Locale('pt', 'BR');
  int numberOfRepeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      descriptionController.text = widget.model!.description;
      valueController.text = widget.model!.value.toString();
      _isEditing = true;
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
    final titleText = _isEditing ? "Editando receita" : "Nova receita";
    final revenueModel = widget.model;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(7, 20, 7, 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                  hintText: "Descrição",
                  border: InputBorder.none,
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira um valor";
                  }
                  double? numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue <= 0) {
                    return "Deve ser maior que 0";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: valueController,
                focusNode: valueFocusNode,
                decoration: const InputDecoration(
                  hintText: "Valor",
                  border: InputBorder.none,
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.circleCheck),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Recebeu?",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isReceived,
                    onChanged: (newValue) async {
                      setState(() {
                        isReceived = newValue;
                      });
                      final revenue =
                          await RevenueController().getRevenueFromFirestore();
                      if (revenue.isNotEmpty) {
                        final firstRevenue = revenue.first;
                        RevenueController()
                            .updateReceivedStatus(firstRevenue.id, newValue);
                      }
                    },
                  ),
                ],
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    locale: ptBr,
                    initialDate: selectedPicker,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (picked != null) {
                    setState(
                      () {
                        selectedPicker = picked;
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.calendar),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            DateFormat.yMMMMd('pt_BR').format(selectedPicker),
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CatalogView(isSelecting: true),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.tags),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Catálogo",
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.rotateRight),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Repetir",
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: isRepeat,
                        onChanged: (newValue) async {
                          setState(() {
                            isRepeat = newValue;
                          });
                          final revenue = await RevenueController()
                              .getRevenueFromFirestore();

                          if (revenue.isNotEmpty) {
                            final firstRevenue = revenue.first;
                            RevenueController()
                                .updateRepeatStatus(firstRevenue.id, newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  if (isRepeat)
                    Column(
                      children: [
                        const Text("Quantidade de Repetições:"),
                        CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              numberOfRepeats = value + 1;
                            });
                          },
                          children: List.generate(10, (index) {
                            return Text((index + 1).toString());
                          }),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("$numberOfRepeats vezes de R\$ 55.000,00"),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Consumer<RevenueController>(
                builder: (BuildContext context, RevenueController revenue,
                    Widget? widget) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (!_isEditing) {
                        if (_formKey.currentState!.validate()) {
                          RevenueModel revenue = RevenueModel(
                            id: invoicingId,
                            description: descriptionController.text,
                            value: double.parse(valueController.text),
                            isReceived: isReceived,
                            receiptDate: selectedPicker,
                            isRepeat: numberOfRepeats,
                          );

                          if (revenueModel != null) {
                            revenue.id = revenueModel.id;
                          }

                          await RevenueController()
                              .addRevenueToFirestore(revenue);

                          if (!_isEditing) {
                            showSnackbar(
                              context: context,
                              menssager: "Receita adicionada",
                              isError: false,
                            );
                          } else {
                            showSnackbar(
                              context: context,
                              menssager: "Receita editada",
                              isError: false,
                            );
                          }

                          Navigator.pop(context);
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      minimumSize: const Size(300, 40),
                    ),
                    child: const Text("CONFIRMAR"),
                  );
                },
              )
            ],
            // const SizedBox(height: 12),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     if (!_isEditing2)
            //       Consumer<CashPaymentController>(
            //         builder: (BuildContext context,
            //             CashPaymentController inCash, Widget? widget) {
            //           return SizedBox(
            //             width: 100,
            //             child: TextButton(
            //               onPressed: () async {
            //                 if (_formKey.currentState!.validate()) {
            //                   CashPayment received = CashPayment(
            //                     description: descriptionController.text,
            //                     value: double.parse(valueController.text),
            //                     date: DateTime.now(),
            //                     id: invoicingId,
            //                   );
            //
            //                   if (cashPaymentModel != null) {
            //                     received.id = cashPaymentModel.id;
            //                   }
            //
            //                   await CashPaymentController()
            //                       .addPaymentToFirestore(received);
            //
            //                   if (!_isEditing1 && !_isEditing2) {
            //                     showSnackbar(
            //                         context: context,
            //                         isError: false,
            //                         menssager: "Pagamento adicionado");
            //                   } else {
            //                     showSnackbar(
            //                         context: context,
            //                         isError: false,
            //                         menssager: "Pagamento editado");
            //                   }
            //
            //                   Navigator.pop(context);
            //                 }
            //               },
            //               style: TextButton.styleFrom(
            //                 backgroundColor: const Color(0xFF5CE1E6),
            //               ),
            //               child: Text(
            //                 buttonText1,
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     if (!_isEditing1)
            //       Consumer<DeferredPaymentController>(
            //         builder: (BuildContext context,
            //             DeferredPaymentController inTerm, Widget? widget) {
            //           return SizedBox(
            //             width: 100,
            //             child: TextButton(
            //               onPressed: () async {
            //                 if (_formKey.currentState!.validate()) {
            //                   DeferredPayment pending = DeferredPayment(
            //                     description: descriptionController.text,
            //                     value: double.parse(valueController.text),
            //                     date: DateTime.now(),
            //                     id: invoicingId,
            //                   );
            //
            //                   if (deferredPaymentModel != null) {
            //                     pending.id = deferredPaymentModel.id;
            //                   }
            //
            //                   await DeferredPaymentController()
            //                       .addPaymentToFirestore(pending);
            //
            //                   if (!_isEditing1 && !_isEditing2) {
            //                     showSnackbar(
            //                         context: context,
            //                         isError: false,
            //                         menssager: "Pagamento adicionado");
            //                   } else {
            //                     showSnackbar(
            //                         context: context,
            //                         isError: false,
            //                         menssager: "Pagamento editado");
            //                   }
            //
            //                   Navigator.pop(context);
            //                 }
            //               },
            //               style: TextButton.styleFrom(
            //                 backgroundColor: const Color(0xFF5CE1E6),
            //               ),
            //               child: Text(
            //                 buttonText2,
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import '../../../controllers/business/revenue_controller.dart';
// import '../../../controllers/business/deferred_payment_controller.dart';
// import '../../../models/business/revenue_model.dart';
// import '../../../models/business/deferred_payment.dart';
// import '../../show_snackbar.dart';
//
// class NewRevenueBottomSheet {
//   static void show(BuildContext context,
//       {CashPayment? model1, DeferredPayment? model2}) {
//     showModalBottomSheet(
//       useSafeArea: true,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(24),
//         ),
//       ),
//       context: context,
//       builder: (BuildContext context) {
//         return _BottomSheetNewRevenue(
//           model1: model1,
//           model2: model2,
//         );
//       },
//     );
//   }
// }
//
// class _BottomSheetNewRevenue extends StatefulWidget {
//   final CashPayment? model1;
//   final DeferredPayment? model2;
//
//   const _BottomSheetNewRevenue({this.model1, this.model2});
//
//   @override
//   __BottomSheetNewRevenueState createState() => __BottomSheetNewRevenueState();
// }
//
// class __BottomSheetNewRevenueState extends State<_BottomSheetNewRevenue> {
//   bool _isEditing1 = false;
//   final _formKey = GlobalKey<FormState>();
//   final descriptionController = TextEditingController();
//   final valueController = TextEditingController();
//   String invoicingId = const Uuid().v1();
//   final descriptionFocusNode = FocusNode();
//   final valueFocusNode = FocusNode();
//   bool _isEditing2 = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.model1 != null) {
//       descriptionController.text = widget.model1!.description;
//       valueController.text = widget.model1!.value.toString();
//       _isEditing1 = true;
//     }
//     if (widget.model2 != null) {
//       descriptionController.text = widget.model2!.description;
//       valueController.text = widget.model2!.value.toString();
//       _isEditing2 = true;
//     }
//   }
//
//   @override
//   void dispose() {
//     descriptionFocusNode.dispose();
//     valueFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cashPaymentModel = widget.model1;
//     final deferredPaymentModel = widget.model2;
//     final titleText = _isEditing1 || _isEditing2
//         ? "Editando pagamento"
//         : "Adicione um novo pagamento";
//     final buttonText1 = _isEditing1 ? "Confirmar" : "RECEBIDO";
//     final buttonText2 = _isEditing2 ? "Confirmar" : "PENDENTE";
//     return SingleChildScrollView(
//       reverse: true,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.8,
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Center(
//                 child: Text(
//                   titleText,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 validator: (String? value) {
//                   if (value!.isEmpty) {
//                     return "Insira uma descrição";
//                   }
//                   if (value.length > 80) {
//                     return "Descrição muito grande";
//                   }
//                   return null;
//                 },
//                 keyboardType: TextInputType.text,
//                 controller: descriptionController,
//                 focusNode: descriptionFocusNode,
//                 decoration: const InputDecoration(
//                   labelText: 'Descrição',
//                   labelStyle: TextStyle(color: Colors.white),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "Insira um valor";
//                   }
//                   return null;
//                 },
//                 keyboardType: TextInputType.number,
//                 controller: valueController,
//                 focusNode: valueFocusNode,
//                 decoration: const InputDecoration(
//                   labelText: 'Valor',
//                   labelStyle: TextStyle(color: Colors.white),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               if (!_isEditing1 && !_isEditing2)
//                 const Center(
//                   child: Text(
//                     'O pagamento já foi recebido?',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 12),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   if (!_isEditing2)
//                     Consumer<CashPaymentController>(
//                       builder: (BuildContext context,
//                           CashPaymentController inCash, Widget? widget) {
//                         return SizedBox(
//                           width: 100,
//                           child: TextButton(
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 CashPayment received = CashPayment(
//                                   description: descriptionController.text,
//                                   value: double.parse(valueController.text),
//                                   date: DateTime.now(),
//                                   id: invoicingId,
//                                 );
//
//                                 if (cashPaymentModel != null) {
//                                   received.id = cashPaymentModel.id;
//                                 }
//
//                                 await CashPaymentController()
//                                     .addPaymentToFirestore(received);
//
//                                 if (!_isEditing1 && !_isEditing2) {
//                                   showSnackbar(
//                                       context: context,
//                                       isError: false,
//                                       menssager: "Pagamento adicionado");
//                                 } else {
//                                   showSnackbar(
//                                       context: context,
//                                       isError: false,
//                                       menssager: "Pagamento editado");
//                                 }
//
//                                 Navigator.pop(context);
//                               }
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: const Color(0xFF5CE1E6),
//                             ),
//                             child: Text(
//                               buttonText1,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   if (!_isEditing1)
//                     Consumer<DeferredPaymentController>(
//                       builder: (BuildContext context,
//                           DeferredPaymentController inTerm, Widget? widget) {
//                         return SizedBox(
//                           width: 100,
//                           child: TextButton(
//                             onPressed: () async {
//                               if (_formKey.currentState!.validate()) {
//                                 DeferredPayment pending = DeferredPayment(
//                                   description: descriptionController.text,
//                                   value: double.parse(valueController.text),
//                                   date: DateTime.now(),
//                                   id: invoicingId,
//                                 );
//
//                                 if (deferredPaymentModel != null) {
//                                   pending.id = deferredPaymentModel.id;
//                                 }
//
//                                 await DeferredPaymentController()
//                                     .addPaymentToFirestore(pending);
//
//                                 if (!_isEditing1 && !_isEditing2) {
//                                   showSnackbar(
//                                       context: context,
//                                       isError: false,
//                                       menssager: "Pagamento adicionado");
//                                 } else {
//                                   showSnackbar(
//                                       context: context,
//                                       isError: false,
//                                       menssager: "Pagamento editado");
//                                 }
//
//                                 Navigator.pop(context);
//                               }
//                             },
//                             style: TextButton.styleFrom(
//                               backgroundColor: const Color(0xFF5CE1E6),
//                             ),
//                             child: Text(
//                               buttonText2,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
