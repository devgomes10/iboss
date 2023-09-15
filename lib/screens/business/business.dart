import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/show_confirmation_password.dart';
import 'package:iboss/repositories/authentication/auth_service.dart';
import 'package:iboss/repositories/business/enterprise_reserve_repository.dart';
import 'package:iboss/screens/business/revenue.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';
import 'expense.dart';
import 'package:provider/provider.dart';
import '../../repositories/business/wage_repository.dart';

class Business extends StatefulWidget {
  final User user;

  const Business({super.key, required this.user});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  // variables
  final DateTime _selectedDate = DateTime.now();
  double totalCashPayments = 0.0;
  double totalDeferredPayments = 0.0;
  double totalFixedExpenses = 0.0;
  double totalVariableExpense = 0.0;
  TextEditingController wageController = TextEditingController();
  TextEditingController reservationController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    final wageRepository = Provider.of<WageRepository>(context);
    final enterpriseReserve = Provider.of<EnterpriseReserveRepository>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.rightFromBracket),
              title: const Text("Sair"),
              onTap: () {
                AuthService().logOut();
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.trash),
              title: const Text("Remover conta"),
              onTap: () {
                showConfirmationPassword(context: context, email: "");
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Empreendimento'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, right: 7, bottom: 10, left: 7),
        child: Column(
          children: [
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Revenue(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Faturamento',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const FaIcon(
                              FontAwesomeIcons.arrowTrendUp,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        StreamBuilder<double>(
                          stream: CombineLatestStream.combine2(
                            CashPaymentRepository()
                                .getTotalCashPaymentsByMonth(_selectedDate),
                            DeferredPaymentRepository()
                                .getTotalDeferredPaymentsByMonth(_selectedDate),
                            (double totalCash, double totalDeferred) =>
                                totalCash + totalDeferred,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final totalValue = snapshot.data;
                              return Text(
                                real.format(totalValue!),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('...');
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Recebidos",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StreamBuilder<double>(
                                  stream: CashPaymentRepository()
                                      .getTotalCashPaymentsByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalCashPayments = snapshot.data;
                                      return Text(
                                        real.format(totalCashPayments),
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("...");
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Pendentes",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StreamBuilder<double>(
                                  stream: DeferredPaymentRepository()
                                      .getTotalDeferredPaymentsByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalDeferredPayments =
                                          snapshot.data;
                                      return Text(
                                        real.format(totalDeferredPayments),
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("...");
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 15,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Expense(),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Despesas',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const FaIcon(
                              FontAwesomeIcons.arrowTrendDown,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        StreamBuilder<double>(
                          stream: CombineLatestStream.combine2(
                            FixedExpenseRepository()
                                .getTotalFixedExpensesByMonth(_selectedDate),
                            VariableExpenseRepository()
                                .getTotalVariableExpensesByMonth(_selectedDate),
                            (double totalFixed, double totalVariable) =>
                                totalFixed + totalVariable,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final totalValue = snapshot.data;
                              return Text(
                                real.format(totalValue!),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('...');
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Fixas",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StreamBuilder<double>(
                                  stream: FixedExpenseRepository()
                                      .getTotalFixedExpensesByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalFixedExpense = snapshot.data;
                                      return Text(
                                        real.format(totalFixedExpense),
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("...");
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Variáveis",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StreamBuilder<double>(
                                  stream: VariableExpenseRepository()
                                      .getTotalVariableExpensesByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalVariableExpense =
                                          snapshot.data;
                                      return Text(
                                        real.format(totalVariableExpense),
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("...");
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 15,
            ),
            ListTile(
              title: Text(
                'Pró-labore',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: FutureBuilder<double?>(
                future: wageRepository.getCurrentWage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Valor não encontrado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Text(
                      'Adicione um valor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else {
                    final wageValue = snapshot.data!;
                    return Text(
                      real.format(wageValue),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            scrollable: true,
                            title: Text(
                              'Qual o seu pró-labore atual',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: wageController,
                                        decoration: const InputDecoration(
                                          labelText: 'Pró-labore',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                                child: const Text('Cancelar'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  final newWage =
                                                      double.tryParse(
                                                              wageController
                                                                  .text) ??
                                                          0.0;
                                                  wageRepository
                                                      .updateWage(newWage);

                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                                child: const Text('Confirmar'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.penToSquare),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.transparent,
              height: 15,
            ),
            ListTile(
              title: Text(
                'Reserva de emergência',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: FutureBuilder<double?>(
                future: enterpriseReserve.getCurrentReserveEnterprise(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Valor não encontrado',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else if (!snapshot.hasData) {
                    return Text(
                      'Adicione um valor',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  } else {
                    final reservationValue = snapshot.data!;
                    return Text(
                      real.format(reservationValue),
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            scrollable: true,
                            title: Text(
                              'Qual sua reserva de emergência atual?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: reservationController,
                                        decoration: const InputDecoration(
                                          labelText: 'Reserva de emergência',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                                child: const Text('Cancelar'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  final newReserve =
                                                      double.tryParse(
                                                              reservationController
                                                                  .text) ??
                                                          0.0;
                                                  enterpriseReserve
                                                      .updateReserveEnterprise(
                                                          newReserve);

                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                                child: const Text('Confirmar'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const FaIcon(FontAwesomeIcons.penToSquare),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
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
