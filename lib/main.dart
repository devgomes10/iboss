import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/controllers/business/cash_payment_controller.dart';
import 'package:iboss/controllers/business/deferred_payment_controller.dart';
import 'package:iboss/controllers/business/fixed_expense_controller.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:iboss/controllers/goals/company_goals_controller.dart';
import 'package:iboss/controllers/goals/personal_goals_controller.dart';
import 'package:iboss/controllers/personal/fixed_entry_controller.dart';
import 'package:iboss/controllers/personal/fixed_outflow_controller.dart';
import 'package:iboss/controllers/personal/variable_entry_controller.dart';
import 'package:iboss/controllers/personal/variable_outflow_controller.dart';
import 'package:iboss/screens/authentication/auth_screen.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/dark_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CashPaymentController()),
        ChangeNotifierProvider(
            create: (context) => DeferredPaymentController()),
        ChangeNotifierProvider(create: (context) => CompanyGoalsController()),
        ChangeNotifierProvider(create: (context) => FixedExpenseController()),
        ChangeNotifierProvider(
            create: (context) => VariableExpenseController()),
        ChangeNotifierProvider(create: (context) => FixedEntryController()),
        ChangeNotifierProvider(create: (context) => VariableEntryController()),
        ChangeNotifierProvider(create: (context) => FixedOutflowController()),
        ChangeNotifierProvider(
            create: (context) => VariableOutflowController()),
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
      home: const ScreenRouter(),
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
          if (snapshot.hasData) {
            return MenuNavigation(
              transaction: snapshot.data!,
            );
          } else {
            return const AuthScreen();
          }
        }
      },
    );
  }
}

// class ScreenRouter extends StatelessWidget {
//   const ScreenRouter({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseAuth.instance.userChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           final user = FirebaseAuth.instance.currentUser;
//           final currentDate = DateTime.now();
//
//           if (user != null) {
//             // O usuário está conectado.
//             final trialStartDate = user.metadata.creationTime?.toLocal(); // Data de criação da conta.
//             final trialEndDate = trialStartDate?.add(const Duration(days: 15)); // 15 dias de avaliação gratuita.
//
//             if (currentDate.isBefore(trialEndDate!)) {
//               // O usuário ainda está dentro do período de avaliação gratuita.
//               return MenuNavigation(transaction: user);
//             } else {
//               // O período de avaliação gratuita expirou, redirecione para SubscriptionScreen().
//               return const SubscriptionScreen();
//             }
//           } else {
//             // O usuário não está conectado, exiba a tela de autenticação.
//             return const AuthScreen();
//           }
//         }
//       },
//     );
//   }
// }
