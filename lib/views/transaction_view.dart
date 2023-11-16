// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iboss/controllers/transaction_controller.dart';
// import 'package:iboss/models/transaction_model.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/Uuid.dart';
//
// class TransactionView extends StatefulWidget {
//   const TransactionView({super.key});
//
//   @override
//   State<TransactionView> createState() => _TransactionViewState();
// }
//
// class _TransactionViewState extends State<TransactionView> {
//   DateTime _selectedDate = DateTime.now();
//   final descriptionController = TextEditingController();
//   final valueController = TextEditingController();
//   final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
//   String invoicingId = const Uuid().v1();
//
//   void _changeMonth(bool increment) {
//     setState(() {
//       if (increment) {
//         _selectedDate =
//             DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
//       } else {
//         _selectedDate =
//             DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Transações"),
//         centerTitle: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const FaIcon(FontAwesomeIcons.plus),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 6,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 IconButton(
//                   icon: const FaIcon(FontAwesomeIcons.caretLeft),
//                   onPressed: () => _changeMonth(false),
//                 ),
//                 Text(
//                   DateFormat.yMMMM('pt_BR').format(_selectedDate),
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const FaIcon(FontAwesomeIcons.caretRight),
//                   onPressed: () => _changeMonth(true),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<List<TransactionModel>>(
//               stream:
//                   TransactionController().getTransactionByMonth(_selectedDate),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<TransactionModel>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(
//                     child: Text('Erro ao carregar dados'),
//                   );
//                 }
//                 final revenues = snapshot.data;
//                 if (revenues == null || revenues.isEmpty) {
//                   return const Center(
//                     child: Text('Nenhum dado disponível'),
//                   );
//                 }
//                 return ListView.separated(itemBuilder: (BuildContext context, int i), separatorBuilder: separatorBuilder, itemCount: itemCount)
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
