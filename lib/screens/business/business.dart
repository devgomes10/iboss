import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/components/box_card.dart';
import 'package:iboss/components/drawer_component.dart';
import 'package:iboss/controllers/business/cash_payment_controller.dart';
import 'package:iboss/controllers/business/deferred_payment_controller.dart';
import 'package:iboss/controllers/business/fixed_expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:iboss/screens/business/revenue.dart';
import 'package:rxdart/rxdart.dart';
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
                CashPaymentController()
                    .getTotalCashPaymentsByMonth(_selectedDate),
                DeferredPaymentController()
                    .getTotalDeferredPaymentsByMonth(_selectedDate),
                (double totalCash, double totalDeferred) =>
                    totalCash + totalDeferred,
              ),
              stream1: CashPaymentController()
                  .getTotalCashPaymentsByMonth(_selectedDate),
              stream2: DeferredPaymentController()
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
                FixedExpenseController()
                    .getTotalFixedExpensesByMonth(_selectedDate),
                VariableExpenseController()
                    .getTotalVariableExpensesByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedExpenseController()
                  .getTotalFixedExpensesByMonth(_selectedDate),
              stream2: VariableExpenseController()
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
