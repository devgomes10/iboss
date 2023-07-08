import 'package:flutter/material.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/repositories/cash_payment_repository.dart';
import 'package:iboss/repositories/company_goals_repository.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CashPaymentRepository(cashPayments: [])),
    ChangeNotifierProvider(create: (context) => CompanyGoalsRepository(companyGoals: [])),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
