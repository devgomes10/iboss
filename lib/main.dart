import 'package:flutter/material.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/repositories/business/deferred_payment_repository.dart';
import 'package:iboss/repositories/business/fixed_expense_repository.dart';
import 'package:iboss/repositories/business/variable_expense_repository.dart';
import 'package:iboss/repositories/goals/company_goals_repository.dart';
import 'package:iboss/repositories/personal/fixed_outflow_repository.dart';
import 'package:iboss/repositories/personal/variable_entry_repository.dart';
import 'package:iboss/repositories/personal/variable_outflow_repository.dart';
import 'package:iboss/screens/login/login.dart';
import 'package:iboss/screens/register/register.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:iboss/theme/dark_theme.dart';
import 'package:iboss/repositories/business/cash_payment_repository.dart';
import 'package:iboss/repositories/personal/fixed_entry_repository.dart';
import 'package:iboss/repositories/goals/personal_goals_repository.dart';
import 'package:iboss/repositories/personal/personal_reservation_repository.dart';
import 'package:iboss/repositories/business/wage_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
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
      home: Settings(),
    );
  }
}