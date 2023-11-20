import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/components/forms/business/expense_form.dart';
import 'package:iboss/controllers/business/product_controller.dart';
import 'package:iboss/controllers/business/category_controller.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:iboss/controllers/business/deferred_payment_controller.dart';
import 'package:iboss/controllers/business/expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:iboss/controllers/goals/goal_controller.dart';
import 'package:iboss/controllers/goals/personal_goals_controller.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/controllers/transaction_controller.dart';
import 'package:iboss/dark_theme.dart';
import 'package:iboss/views/authentication/auth_view.dart';
import 'package:iboss/views/business/expense_view.dart';
import 'package:iboss/views/business/revenue_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/forms/business/revenue_form.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionController()),
        ChangeNotifierProvider(create: (context) => CategoryController()),
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (context) => RevenueController()),
        ChangeNotifierProvider(create: (context) => DeferredPaymentController()),
        ChangeNotifierProvider(create: (context) => GoalController()),
        ChangeNotifierProvider(create: (context) => ExpenseController()),
        ChangeNotifierProvider(create: (context) => VariableExpenseController()),
        ChangeNotifierProvider(create: (context) => PersonalGoalsController()),
      ],
      child: const Bossover(),
    ),
  );
}

class Bossover extends StatelessWidget {
  const Bossover({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    return MaterialApp(
      localeResolutionCallback: (locale, supported) {
        return const Locale('pt', 'BR');
      },
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      title: 'Bossover',
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      initialRoute: "/login",
      routes: {
        "/login": (context) => ScreenRouter(),
        "/revenues": (context) => RevenueView(),
        "/revenueForm": (context) => RevenueForm(),
        "/expenses": (context) => ExpenseView(),
        "/ExpenseForm": (context) => ExpenseForm(),
      },
    );
  }
}

class ScreenRouter extends StatelessWidget {
  const ScreenRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return MenuNavigation(
              transaction: snapshot.data!,
            );
          } else {
            return const AuthView();
          }
        }
      },
    );
  }
}
