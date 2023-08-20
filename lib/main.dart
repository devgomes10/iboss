import 'package:flutter/material.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/dark_theme.dart';
import 'package:iboss/repositories/cash_payment_repository.dart';
import 'package:iboss/repositories/company_goals_repository.dart';
import 'package:iboss/repositories/deferred_payment_repository.dart';
import 'package:iboss/repositories/fixed_entry_repository.dart';
import 'package:iboss/repositories/fixed_expense_repository.dart';
import 'package:iboss/repositories/fixed_outflow_repository.dart';
import 'package:iboss/repositories/personal_goals_repository.dart';
import 'package:iboss/repositories/personal_reservation_repository.dart';
import 'package:iboss/repositories/variable_entry_repository.dart';
import 'package:iboss/repositories/variable_expense_repository.dart';
import 'package:iboss/repositories/variable_outflow_repository.dart';
import 'package:iboss/repositories/wage_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:iboss/screens/business_screens/revenue.dart';
import 'package:iboss/screens/login.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (context) => CashPaymentRepository(cashPayments: [])),
    ChangeNotifierProvider(
        create: (context) => CompanyGoalsRepository(companyGoals: [])),
    ChangeNotifierProvider(
        create: (context) => DeferredPaymentRepository(deferredPayments: [])),
    ChangeNotifierProvider(
        create: (context) => FixedExpenseRepository(fixedExpenses: [])),
    ChangeNotifierProvider(
        create: (context) => VariableExpenseRepository(variableExpenses: [])),
    ChangeNotifierProvider(
        create: (context) => FixedEntryRepository(fixedEntry: [])),
    ChangeNotifierProvider(
        create: (context) => VariableEntryRepository(variableEntry: [])),
    ChangeNotifierProvider(
        create: (context) => FixedOutflowRepository(fixedOutflow: [])),
    ChangeNotifierProvider(
        create: (context) => VariableOutflowRepository(variableOutflow: [])),
    ChangeNotifierProvider(
        create: (context) => PersonalGoalsRepository(personalGoals: [])),
    ChangeNotifierProvider(create: (context) => WageRepository(salary: [])),
    ChangeNotifierProvider(
        create: (context) =>
            PersonalReservationRepository(personalReservations: [])),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    return MaterialApp(
      title: 'Evolve',
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home: MenuNavigation(),
    );
  }
}