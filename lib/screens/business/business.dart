import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/box_card.dart';
import 'package:iboss/components/drawer_component.dart';
import 'package:iboss/screens/business/revenue.dart';
import 'package:rxdart/rxdart.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';
import 'expense.dart';

class Business extends StatefulWidget {
  final User user;

  const Business({super.key, required this.user});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerComponent(user: widget.user),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Negócio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, right: 7, bottom: 10, left: 7),
        child: Column(
          children: [
            const SizedBox(height: 5),
            BoxCard(
              title: "Receitas",
              subTitle1: "Recebidos",
              subTitle2: "Pendentes",
              streamTotal: CombineLatestStream.combine2(
                CashPaymentRepository()
                    .getTotalCashPaymentsByMonth(_selectedDate),
                DeferredPaymentRepository()
                    .getTotalDeferredPaymentsByMonth(_selectedDate),
                (double totalCash, double totalDeferred) =>
                    totalCash + totalDeferred,
              ),
              stream1: CashPaymentRepository()
                  .getTotalCashPaymentsByMonth(_selectedDate),
              stream2: DeferredPaymentRepository()
                  .getTotalDeferredPaymentsByMonth(_selectedDate),
              screen: const Revenue(),
              color: Colors.green,
            ),
            const Divider(
              color: Colors.transparent,
              height: 50,
            ),
            BoxCard(
              title: "Despesas",
              streamTotal: CombineLatestStream.combine2(
                FixedExpenseRepository()
                    .getTotalFixedExpensesByMonth(_selectedDate),
                VariableExpenseRepository()
                    .getTotalVariableExpensesByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedExpenseRepository()
                  .getTotalFixedExpensesByMonth(_selectedDate),
              stream2: VariableExpenseRepository()
                  .getTotalVariableExpensesByMonth(_selectedDate),
              screen: const Expense(),
              color: Colors.red,
            ),
            const Divider(
              color: Colors.transparent,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
