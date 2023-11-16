import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/business/expense_controller.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:iboss/models/business/expense_model.dart';
import 'package:iboss/models/business/revenue_model.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../components/forms/business/expense_form.dart';
import '../../components/forms/business/revenue_form.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  DateTime _selectedDate = DateTime.now();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

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
        title: Text("Transações"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 6),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.caretRight),
                  onPressed: () => _changeMonth(true),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<RevenueModel>>(
              stream: RevenueController().getRevenueByMonth(_selectedDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<RevenueModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar as receitas'),
                  );
                }
                final revenues = snapshot.data;
                if (revenues == null || revenues.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma receita disponível'),
                  );
                }
                return StreamBuilder<List<ExpenseModel>>(
                  stream: ExpenseController().getExpensesByMonth(_selectedDate),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ExpenseModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar as despesas'),
                      );
                    }
                    final expenses = snapshot.data;
                    if (expenses == null || expenses.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma despesa disponível'),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int i) {
                        bool isRevenue = i < revenues.length;
                        return ListTile(
                          leading: isRevenue
                              ? FaIcon(FontAwesomeIcons.arrowTrendUp)
                              : FaIcon(FontAwesomeIcons.arrowTrendDown),
                          title: isRevenue
                              ? Text(revenues[i].description)
                              : Text(expenses[i - revenues.length].description),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(color: Colors.white),
                      itemCount: revenues.length + expenses.length,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
