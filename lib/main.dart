import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/repositories/cash_payment_repository.dart';
import 'package:iboss/repositories/company_goals_repository.dart';
import 'package:iboss/repositories/company_reservation_repository.dart';
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
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CashPaymentRepository(cashPayments: [])),
    ChangeNotifierProvider(create: (context) => CompanyGoalsRepository(companyGoals: [])),
    ChangeNotifierProvider(create: (context) => DeferredPaymentRepository(deferredPayments: [])),
    ChangeNotifierProvider(create: (context) => FixedExpenseRepository(fixedExpenses: [])),
    ChangeNotifierProvider(create: (context) => VariableExpenseRepository(variableExpenses: [])),
    ChangeNotifierProvider(create: (context) => FixedEntryRepository(fixedEntry: [])),
    ChangeNotifierProvider(create: (context) => VariableEntryRepository(variableEntry: [])),
    ChangeNotifierProvider(create: (context) => FixedOutflowRepository(fixedOutflow: [])),
    ChangeNotifierProvider(create: (context) => VariableOutflowRepository(variableOutflow: [])),
    ChangeNotifierProvider(create: (context) => PersonalGoalsRepository(personalGoals: [])),
    ChangeNotifierProvider(create: (context) => WageRepository(salary: [])),
    ChangeNotifierProvider(create: (context) => PersonalReservationRepository(personalReservations: [])),
    ChangeNotifierProvider(create: (context) => CompanyReservationRepository()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MenuNavigation(),
    );
  }
}
