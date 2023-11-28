import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/transaction_controller.dart';
import 'package:iboss/models/transaction_model.dart';
import 'package:intl/intl.dart';
import '../components/transaction_form.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  var description = "";
  DateTime _selectedDate = DateTime.now();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  StreamSubscription<List<TransactionModel>>? transactionStreamSubscription;

  @override
  void initState() {
    super.initState();
    transactionStreamSubscription = TransactionController()
        .getTransactionByMonth(_selectedDate)
        .listen((data) {});
  }

  @override
  void dispose() {
    transactionStreamSubscription?.cancel();
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
      appBar: AppBar(
        title: const Text("Transações"),
        centerTitle: true,
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
          TextField(
            onChanged: (value) {
              description = value;
            },
            decoration: InputDecoration(
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              filled: true,
              fillColor: const Color.fromARGB(255, 39, 39, 39),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: TransactionController().getTransactionByMonth(_selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TransactionModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar os dados'),
                  );
                }
                final transactions = snapshot.data;
                if (transactions == null || transactions.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado disponível'),
                  );
                }
                return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
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
                      leading: (transactions[i].isRevenue == true)
                          ? const FaIcon(FontAwesomeIcons.arrowTrendUp)
                          : const FaIcon(FontAwesomeIcons.arrowTrendDown),
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
                      trailing: transactions[i].isCompleted == true
                          ? const FaIcon(
                        FontAwesomeIcons.chevronUp,
                        // color: Colors.lightBlue,
                        size: 20,
                      )
                          : const FaIcon(
                        FontAwesomeIcons.minus,
                        // color: Colors.yellow,
                        size: 20,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                  itemCount: transactions.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
