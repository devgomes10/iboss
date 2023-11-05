// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iboss/components/show_snackbar.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
//
// import '../controllers/business/expense_controller.dart';
// import '../controllers/business/variable_expense_controller.dart';
// import '../models/business/expense_model.dart';
// import '../models/business/variable_expense.dart';
//
// class Test extends StatefulWidget {
//   final FixedExpense? model1;
//   final VariableExpense? model2;
//
//   const Test({super.key, this.model1, this.model2});
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   bool _isEditing1 = false;
//   final _formKey = GlobalKey<FormState>();
//   final descriptionController = TextEditingController();
//   final valueController = TextEditingController();
//   String invoicingId = const Uuid().v1();
//   final descriptionFocusNode = FocusNode();
//   final valueFocusNode = FocusNode();
//   bool _isEditing2 = false;
//   bool isRevenue = false;
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
//         : "Nova receita";
//     final buttonText1 = _isEditing1 ? "Confirmar" : "RECEBIDO";
//     final buttonText2 = _isEditing2 ? "Confirmar" : "PENDENTE";
//
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         title: Text(titleText),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(top: 20, right: 7, bottom: 10, left: 7),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
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
//                   hintText: "Descrição",
//                   border: InputBorder.none,
//                 ),
//               ),
//               const Divider(
//                 height: 22,
//                 color: Colors.grey,
//               ),
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
//                   hintText: "Valor",
//                   border: InputBorder.none,
//                 ),
//               ),
//               const Divider(
//                 height: 22,
//                 color: Colors.grey,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       FaIcon(FontAwesomeIcons.circleCheck),
//                       SizedBox(width: 15,),
//                       Text(
//                         "Recebeu?",
//                         style: GoogleFonts.raleway(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Switch(
//                     value: isRevenue,
//                     onChanged: (newValue) async {
//                       setState(() {
//                         isRevenue = newValue;
//                       });
//                       // final fixedExpenses = await FixedExpenseController()
//                       //     .getFixedExpensesFromFirestore();
//                       // final variableExpenses = await VariableExpenseController()
//                       //     .getVariableExpensesFromFirestore();
//                       // if (fixedExpenses.isNotEmpty) {
//                       //   final firstExpense = fixedExpenses.first;
//                       //   FixedExpenseController().updateFixedExpenseStatus(
//                       //       firstExpense.id, newValue);
//                       // }
//                       // if (variableExpenses.isNotEmpty) {
//                       //   final firstExpense = variableExpenses.first;
//                       //   VariableExpenseController().updateVariableExpenseStatus(
//                       //       firstExpense.id, newValue);
//                       // }
//                     },
//                   ),
//                 ],
//               ),
//               const Divider(
//                 height: 22,
//                 color: Colors.grey,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 12, bottom: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.calendar),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Data do recebimento",
//                           style: GoogleFonts.raleway(
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                     FaIcon(FontAwesomeIcons.angleRight),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 height: 22,
//                 color: Colors.grey,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 12, bottom: 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         FaIcon(FontAwesomeIcons.tags),
//                         SizedBox(width: 15,),
//                         Text(
//                           "Catálogo",
//                           style: GoogleFonts.raleway(
//                             fontSize: 20,
//                           ),
//                         ),
//                       ],
//                     ),
//                     FaIcon(FontAwesomeIcons.angleRight),
//                   ],
//                 ),
//               ),
//               const Divider(
//                 height: 22,
//                 color: Colors.grey,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       FaIcon(FontAwesomeIcons.rotateRight),
//                       SizedBox(width: 15,),
//                       Text(
//                         "Repetir",
//                         style: GoogleFonts.raleway(
//                           fontSize: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Switch(
//                       value: isRevenue,
//                       onChanged: (newValue) async {
//                         setState(() {
//                           isRevenue = newValue;
//                         });
//                         // final fixedExpenses = await FixedExpenseController()
//                         //     .getFixedExpensesFromFirestore();
//                         // final variableExpenses = await VariableExpenseController()
//                         //     .getVariableExpensesFromFirestore();
//                         // if (fixedExpenses.isNotEmpty) {
//                         //   final firstExpense = fixedExpenses.first;
//                         //   FixedExpenseController().updateFixedExpenseStatus(
//                         //       firstExpense.id, newValue);
//                       }
//                     // if (variableExpenses.isNotEmpty) {
//                     //   final firstExpense = variableExpenses.first;
//                     //   VariableExpenseController().updateVariableExpenseStatus(
//                     //       firstExpense.id, newValue);
//                     // }
//                     // },
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 6,
//               ),
//               Text("..."),
//               const SizedBox(
//                 height: 50,
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("CONFIRMAR"),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Theme.of(context).colorScheme.secondary,
//                   minimumSize: Size(300, 40),
//                 ),
//               ),
//             ],
//       //         if (!_isEditing1 && !_isEditing2)
//       //     const Center(
//       //     child: Text(
//       //     'O pagamento já foi recebido?',
//       //     style: TextStyle(
//       //       fontSize: 18,
//       //       fontWeight: FontWeight.bold,
//       //     ),
//       //   ),
//       // ),
//       // const SizedBox(height: 12),
//       // Row(
//       //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//       //   children: [
//       //     if (!_isEditing2)
//       //       Consumer<CashPaymentController>(
//       //         builder: (BuildContext context,
//       //             CashPaymentController inCash, Widget? widget) {
//       //           return SizedBox(
//       //             width: 100,
//       //             child: TextButton(
//       //               onPressed: () async {
//       //                 if (_formKey.currentState!.validate()) {
//       //                   CashPayment received = CashPayment(
//       //                     description: descriptionController.text,
//       //                     value: double.parse(valueController.text),
//       //                     date: DateTime.now(),
//       //                     id: invoicingId,
//       //                   );
//       //
//       //                   if (cashPaymentModel != null) {
//       //                     received.id = cashPaymentModel.id;
//       //                   }
//       //
//       //                   await CashPaymentController()
//       //                       .addPaymentToFirestore(received);
//       //
//       //                   if (!_isEditing1 && !_isEditing2) {
//       //                     showSnackbar(
//       //                         context: context,
//       //                         isError: false,
//       //                         menssager: "Pagamento adicionado");
//       //                   } else {
//       //                     showSnackbar(
//       //                         context: context,
//       //                         isError: false,
//       //                         menssager: "Pagamento editado");
//       //                   }
//       //
//       //                   Navigator.pop(context);
//       //                 }
//       //               },
//       //               style: TextButton.styleFrom(
//       //                 backgroundColor: const Color(0xFF5CE1E6),
//       //               ),
//       //               child: Text(
//       //                 buttonText1,
//       //                 style: const TextStyle(
//       //                   fontSize: 16,
//       //                 ),
//       //               ),
//       //             ),
//       //           );
//       //         },
//       //       ),
//       //     if (!_isEditing1)
//       //       Consumer<DeferredPaymentController>(
//       //         builder: (BuildContext context,
//       //             DeferredPaymentController inTerm, Widget? widget) {
//       //           return SizedBox(
//       //             width: 100,
//       //             child: TextButton(
//       //               onPressed: () async {
//       //                 if (_formKey.currentState!.validate()) {
//       //                   DeferredPayment pending = DeferredPayment(
//       //                     description: descriptionController.text,
//       //                     value: double.parse(valueController.text),
//       //                     date: DateTime.now(),
//       //                     id: invoicingId,
//       //                   );
//       //
//       //                   if (deferredPaymentModel != null) {
//       //                     pending.id = deferredPaymentModel.id;
//       //                   }
//       //
//       //                   await DeferredPaymentController()
//       //                       .addPaymentToFirestore(pending);
//       //
//       //                   if (!_isEditing1 && !_isEditing2) {
//       //                     showSnackbar(
//       //                         context: context,
//       //                         isError: false,
//       //                         menssager: "Pagamento adicionado");
//       //                   } else {
//       //                     showSnackbar(
//       //                         context: context,
//       //                         isError: false,
//       //                         menssager: "Pagamento editado");
//       //                   }
//       //
//       //                   Navigator.pop(context);
//       //                 }
//       //               },
//       //               style: TextButton.styleFrom(
//       //                 backgroundColor: const Color(0xFF5CE1E6),
//       //               ),
//       //               child: Text(
//       //                 buttonText2,
//       //                 style: const TextStyle(
//       //                   fontSize: 16,
//       //                 ),
//       //               ),
//       //             ),
//       //           );
//       //         },
//       //       ),
//       //   ],
//       // ),
//           ),
//         ),
//       ),
//     );
//   }
// }
