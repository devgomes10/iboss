import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/transaction_controller.dart';
import 'package:iboss/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/Uuid.dart';
import '../../components/transaction_form.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transações"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
            child: StreamBuilder<List<TransactionModel>>(
              stream:
              TransactionController().getTransactionByMonth(_selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TransactionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar dados'),
                  );
                }
                final transactions = snapshot.data;
                if (transactions == null || transactions.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado disponível'),
                  );
                }
                return ListView.separated(itemBuilder: (BuildContext context, int i) {
                  TransactionModel model = transactions[i];
                  return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionForm(
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
                      leading: const FaIcon(
                        FontAwesomeIcons.arrowTrendUp,
                        color: Colors.green,
                      ),
                      title: Text(
                        transactions[i].description,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            real.format(
                              transactions[i].value,
                            ),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            " | ${DateFormat.Md("pt_BR").format(transactions[i].transactionDate)}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                      trailing:
                      transactions[i].isCompleted == true ?
                      FaIcon(
                        FontAwesomeIcons.chevronUp,
                        // color: Colors.lightBlue,
                        size: 20,
                      ) : FaIcon(
                        FontAwesomeIcons.minus,
                        // color: Colors.yellow,
                        size: 20,
                      )
                  );
                }, separatorBuilder: (_, __) =>
                const Divider(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                  itemCount: transactions.length,);
              },
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:iboss/controllers/business/expense_controller.dart';
// import 'package:iboss/controllers/business/revenue_controller.dart';
// import 'package:iboss/models/business/expense_model.dart';
// import 'package:iboss/models/business/revenue_model.dart';
// import 'package:intl/intl.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../../components/forms/business/expense_form.dart';
// import '../../components/forms/business/revenue_form.dart';
//
// class Transactions extends StatefulWidget {
//   const Transactions({Key? key});
//
//   @override
//   State<Transactions> createState() => _TransactionsState();
// }
//
// class _TransactionsState extends State<Transactions> {
//   DateTime _selectedDate = DateTime.now();
//   NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
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
//         title: Text("Transações"),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 6),
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
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const FaIcon(FontAwesomeIcons.caretRight),
//                   onPressed: () => _changeMonth(true),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<List<RevenueModel>>(
//               stream: RevenueController().getRevenueByMonth(_selectedDate),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<RevenueModel>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return const Center(
//                     child: Text('Erro ao carregar as receitas'),
//                   );
//                 }
//                 final revenues = snapshot.data;
//                 if (revenues == null || revenues.isEmpty) {
//                   return const Center(
//                     child: Text('Nenhuma receita disponível'),
//                   );
//                 }
//                 return StreamBuilder<List<ExpenseModel>>(
//                   stream: ExpenseController().getExpensesByMonth(_selectedDate),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<List<ExpenseModel>> snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (snapshot.hasError) {
//                       return const Center(
//                         child: Text('Erro ao carregar as despesas'),
//                       );
//                     }
//                     final expenses = snapshot.data;
//                     if (expenses == null || expenses.isEmpty) {
//                       return const Center(
//                         child: Text('Nenhuma despesa disponível'),
//                       );
//                     }
//                     return ListView.separated(
//                       itemBuilder: (BuildContext context, int i) {
//                         bool isRevenue = i < revenues.length;
//                         return ListTile(
//                           leading: isRevenue
//                               ? FaIcon(FontAwesomeIcons.arrowTrendUp)
//                               : FaIcon(FontAwesomeIcons.arrowTrendDown),
//                           title: isRevenue
//                               ? Text(revenues[i].description)
//                               : Text(expenses[i - revenues.length].description),
//                         );
//                       },
//                       separatorBuilder: (_, __) => const Divider(color: Colors.white),
//                       itemCount: revenues.length + expenses.length,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
