// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
//
// class Dash extends StatefulWidget {
//   final Stream<double> stream1;
//   final Stream<double> stream2;
//   final String string1;
//   final String string2;
//
//   const Dash({
//     super.key,
//     required this.stream1,
//     required this.stream2,
//     required this.string1,
//     required this.string2,
//   });
//
//   @override
//   State<Dash> createState() => _DashState();
// }
//
// class _DashState extends State<Dash> {
//   DateTime _selectedDate = DateTime.now();
//   final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
//
//   void _changeMonth(bool increment) {
//     setState(
//       () {
//         if (increment) {
//           _selectedDate =
//               DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
//         } else {
//           _selectedDate =
//               DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
//         }
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//                 DateFormat.yMMMM('pt_BR').format(_selectedDate),
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
//           height: 30,
//         ),
//         SizedBox(
//           width: 250,
//           height: 250,
//           child: StreamBuilder<double>(
//             stream: widget.stream1,
//             builder:
//                 (BuildContext context, AsyncSnapshot<double> stream1Snapshot) {
//               double totalStream1 = stream1Snapshot.data ?? 0.0;
//               return StreamBuilder<double>(
//                 stream: widget.stream2,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<double> stream2Snapshot) {
//                   double totalStream2 = stream2Snapshot.data ?? 0.0;
//                   double total = totalStream1 + totalStream2;
//                   return total > 0
//                       ? Stack(
//                           children: [
//                             PieChart(
//                               PieChartData(
//                                 sections: [
//                                   PieChartSectionData(
//                                     showTitle: false,
//                                     color: Colors.yellow,
//                                     value: totalStream2,
//                                   ),
//                                   PieChartSectionData(
//                                     showTitle: false,
//                                     color: Colors.green,
//                                     value: totalStream1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Center(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       const Text(
//                                         'Total',
//                                         style: TextStyle(
//                                           fontSize: 25,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         real.format(total),
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )
//                       : const Center(
//                           child: Text('Sem registros'),
//                         );
//                 },
//               );
//             },
//           ),
//         ),
//         const SizedBox(
//           height: 40,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   widget.string1,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 StreamBuilder<double>(
//                   stream: widget.stream1,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<double> stream1Snapshot) {
//                     double totalStream1 = stream1Snapshot.data ?? 0.0;
//                     return Text(
//                       real.format(totalStream1),
//                       style: const TextStyle(
//                         fontSize: 20,
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(width: 70),
//             Column(
//               children: [
//                 Text(
//                   widget.string2,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     color: Colors.yellow,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 StreamBuilder<double>(
//                   stream: widget.stream2,
//                   builder: (BuildContext context,
//                       AsyncSnapshot<double> stream2Snapshot) {
//                     double totalStream2 = stream2Snapshot.data ?? 0.0;
//                     return Text(
//                       real.format(totalStream2),
//                       style: const TextStyle(
//                         fontSize: 20,
//                         color: Colors.yellow,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
