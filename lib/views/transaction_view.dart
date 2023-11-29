import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/transaction_controller.dart';
import 'package:iboss/models/transaction_model.dart';
import 'package:intl/intl.dart';
import '../components/transaction_form.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({Key? key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  String name = "";
  DateTime _selectedDate = DateTime.now();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  StreamSubscription<List<TransactionModel>>? transactionStreamSubscription;
  bool showRevenues = false;
  bool showExpenses = false;

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

  void _setTransactionType(String type) {
    setState(() {
      showRevenues = type == 'Receitas';
      showExpenses = type == 'Despesas';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              _setTransactionType(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Transações',
                child: Text('Transações'),
              ),
              const PopupMenuItem<String>(
                value: 'Receitas',
                child: Text('Receitas'),
              ),
              const PopupMenuItem<String>(
                value: 'Despesas',
                child: Text('Despesas'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 6),
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
          const SizedBox(height: 6),
          TextField(
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
          const SizedBox(height: 6),
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
                    child: Text('Erro ao carregar os dados'),
                  );
                }
                final transactions = snapshot.data;
                if (transactions == null || transactions.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dado disponível'),
                  );
                }

                // Agrupando transações por data
                Map<String, List<TransactionModel>> groupedTransactions = {};
                for (var transaction in transactions) {
                  String formattedDate = DateFormat('EEEE, dd', 'pt_BR')
                      .format(transaction.transactionDate);
                  if (!groupedTransactions.containsKey(formattedDate)) {
                    groupedTransactions[formattedDate] = [];
                  }
                  groupedTransactions[formattedDate]!.add(transaction);
                }

                return ListView.builder(
                  itemBuilder: (BuildContext context, int i) {
                    String date = groupedTransactions.keys.elementAt(i);
                    List<TransactionModel> dateTransactions =
                    groupedTransactions[date]!;

                    // Filtra as transações com base na busca por nome
                    List<TransactionModel> filteredTransactions =
                    dateTransactions
                        .where((transaction) =>
                    (showRevenues && transaction.isRevenue) ||
                        (showExpenses && !transaction.isRevenue) ||
                        (!showRevenues && !showExpenses &&
                            transaction.description
                                .toLowerCase()
                                .startsWith(name.toLowerCase())))
                        .toList();

                    // Se não houver transações após a filtragem, retorna um contêiner vazio
                    if (filteredTransactions.isEmpty) {
                      return Container();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            date,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.separated(
                          itemBuilder: (BuildContext context, int j) {
                            TransactionModel model = filteredTransactions[j];
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                              ),
                              leading: (filteredTransactions[j].isRevenue ==
                                  true)
                                  ? const FaIcon(FontAwesomeIcons.arrowTrendUp)
                                  : const FaIcon(
                                  FontAwesomeIcons.arrowTrendDown),
                              title: Text(
                                filteredTransactions[j].description,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    real.format(filteredTransactions[j].value),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    " | ${DateFormat.Md("pt_BR").format(filteredTransactions[j].transactionDate)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                              trailing:
                              filteredTransactions[j].isCompleted == true
                                  ? const FaIcon(
                                FontAwesomeIcons.chevronUp,
                                size: 20,
                              )
                                  : const FaIcon(
                                FontAwesomeIcons.minus,
                                size: 20,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: filteredTransactions.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ],
                    );
                  },
                  itemCount: groupedTransactions.keys.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    if (showRevenues) {
      return 'Receitas';
    } else if (showExpenses) {
      return 'Despesas';
    } else {
      return 'Transações';
    }
  }
}
