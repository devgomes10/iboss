import 'package:flutter/material.dart';
import 'package:iboss/data/revenue_inherited.dart';
import 'package:iboss/screens/business_screens/revenue.dart';

void main() {
  runApp(const MyApp());
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
      home: RevenueInhereted(child: const Revenue()),
    );
  }
}
