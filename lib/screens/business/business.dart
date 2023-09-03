import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/business/revenue.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/business/cash_payment_repository.dart';
import '../../repositories/business/deferred_payment_repository.dart';
import '../../repositories/business/fixed_expense_repository.dart';
import '../../repositories/business/variable_expense_repository.dart';
import 'expense.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {

  // variables
  final DateTime _selectedDate = DateTime.now();
  double totalCashPayments =0.0;
  double totalDeferredPayments = 0.0;
  double totalFixedExpenses = 0.0;
  double totalVariableExpense = 0.0;
  TextEditingController wageController = TextEditingController();
  TextEditingController reservationController = TextEditingController();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    // total cash payments
    final cashPaymentRepository = Provider.of<CashPaymentRepository>(context);
    Stream<double> totalCashPaymentsStream =
    cashPaymentRepository.getTotalCashPaymentsByMonthStream(_selectedDate);

    // total payments on time
    final deferredPaymentRepository =
        Provider.of<DeferredPaymentRepository>(context);
    totalDeferredPayments = deferredPaymentRepository
        .getTotalDeferredPaymentsByMonth(_selectedDate);

    // total fixed expenses
    final fixedExpenseRepository = Provider.of<FixedExpenseRepository>(context);
    totalFixedExpenses =
        fixedExpenseRepository.getTotalFixedExpensesByMonth(_selectedDate);

    // total variable expenses
    final variableExpensesRepository =
        Provider.of<VariableExpenseRepository>(context);
    totalVariableExpense = variableExpensesRepository
        .getTotalVariableExpensesByMonth(_selectedDate);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Empresa'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Settings(),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.gear,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
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
                            'Receitas',
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
                        stream: totalCashPaymentsStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final totalCashPaymentsValue = snapshot.data;
                            return Text(
                              real.format(totalCashPaymentsValue! + totalDeferredPayments),
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Erro ao carregar dados.');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Pagos",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                real.format(totalCashPayments),
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Pendentes",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                real.format(totalDeferredPayments),
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
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
            const Divider(
              color: Colors.transparent,
              height: 25,
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
                            'Gastos',
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
                      Text(
                        real.format(totalFixedExpenses + totalVariableExpense),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Fixos",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                real.format(totalFixedExpenses),
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Variáveis",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                real.format(totalVariableExpense),
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
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
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            ListTile(
              title: Text(
                'Pró-labore',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'R\$ 100,00',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: SizedBox(
                width: 110,
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
                              'Adicione seu pró-labore atual',
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
                                        keyboardType: TextInputType.text,
                                        controller: wageController,
                                        decoration: const InputDecoration(
                                          labelText: 'Pró-labore',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.grey[200],
                                                ),
                                                child: const Text('Cancelar'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.grey[200],
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
              height: 12,
            ),
            ListTile(
              title: Text(
                'Reserva de emergência',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'RS 100,00',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: SizedBox(
                width: 110,
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
                              'Adicione sua reserva de emêrgencia atual',
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
                                        keyboardType: TextInputType.text,
                                        controller: reservationController,
                                        decoration: const InputDecoration(
                                          labelText: 'Reserva de emergência',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.grey[200],
                                                ),
                                                child: const Text('Cancelar'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.grey[200],
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
          ],
        ),
      ),
    );
  }
}
