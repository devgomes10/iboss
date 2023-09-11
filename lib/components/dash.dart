// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
//
// class Dash extends StatefulWidget {
//   final DateTime selectedDate;
//   final double totalCashPayments;
//   final double totalDeferredPayments;
//   final double stream;
//   final double var1;
//   final double stream2;
//
//   Dash ({
//     required this.selectedDate,
//     required this.totalCashPayments,
//     required this.totalDeferredPayments,
//     required this.stream,
//     required this.var1,
//     required this.stream2,
//   });
//
//   @override
//   State<Dash> createState() => _DashState();
// }
//
// class _DashState extends State<Dash> {
//   final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
//
//   DateTime _selectedDate = DateTime.now();
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
//     final double saldo = widget.totalCashPayments + widget.totalDeferredPayments;
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 8,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: const FaIcon(FontAwesomeIcons.caretLeft),
//                 onPressed: () => _changeMonth(false),
//               ),
//               Text(
//                 DateFormat.yMMMM('pt_BR').format(widget.selectedDate),
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               IconButton(
//                 icon: const FaIcon(FontAwesomeIcons.caretRight),
//                 onPressed: () => _changeMonth(true),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 25,
//         ),
//         SizedBox(
//           width: 250,
//           height: 250,
//           child: StreamBuilder<double>(
//             stream: stream,
//             (BuildContext context,
//             AsyncSnapshot<double> cashSnapshot) {
//     double var1 =
//     cashSnapshot.data ?? 0.0;
//     return StreamBuilder<double>(
//     stream: stream2,
//     builder: (BuildContext context,
//     AsyncSnapshot<double>
//     deferredSnapshot) {
//     double var2 =
//     deferredSnapshot.data ?? 0.0;
//     double total = var1 +
//     var2;
//     return total > 0
//     ? Stack(
//     children: [
//     PieChart(
//     PieChartData(
//     sections: [
//     PieChartSectionData(
//     showTitle: false,
//     color: Colors.yellow,
//     value: widget.totalDeferredPayments,
//     ),
//     PieChartSectionData(
//     showTitle: false,
//     color: Colors.green,
//     value: widget.totalCashPayments,
//     ),
//     ],
//     ),
//     ),
//     Center(
//     child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//     Column(
//     children: [
//     const Text(
//     'Total',
//     style: TextStyle(
//     fontSize: 25,
//     fontWeight: FontWeight.bold,
//     ),
//     ),
//     Text(
//     real.format(saldo),
//     style: const TextStyle(
//     fontWeight: FontWeight.bold,
//     fontSize: 20,
//     ),
//     ),
//     ],
//     ),
//     ],
//     ),
//     ),
//     ],
//     )
//         : const Center(
//     child: Text('Sem registros'),
//     ),
//           ),
//         ),
//         const SizedBox(
//           height: 50,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 const Text(
//                   'Recebidos',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${real.format(widget.totalCashPayments)}',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 70),
//             Column(
//               children: [
//                 const Text(
//                   'Pendentes',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.yellow,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   '${real.format(widget.totalDeferredPayments)}',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.yellow,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
