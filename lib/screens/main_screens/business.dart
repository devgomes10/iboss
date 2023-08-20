import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/menu_navigation.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/cash_payment_repository.dart';
import '../../repositories/deferred_payment_repository.dart';
import '../../repositories/fixed_expense_repository.dart';
import '../../repositories/variable_expense_repository.dart';
import '../business_screens/expense.dart';
import '../business_screens/revenue.dart';

class Business extends StatefulWidget {
  const Business({super.key});

  @override
  State<Business> createState() => _BusinessState();
}

class _BusinessState extends State<Business> {
  // variables
  DateTime _selectedDate = DateTime.now();
  double totalCashPayments = 0.0;
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
    totalCashPayments =
        cashPaymentRepository.getTotalCashPaymentsByMonth(_selectedDate);

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
                  builder: (context) => Settings(),
                ),
              );
            },
            icon: FaIcon(
              FontAwesomeIcons.gear,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Revenue(),
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
                          FaIcon(
                            FontAwesomeIcons.arrowTrendUp,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${real.format(totalCashPayments + totalDeferredPayments)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "À vista",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalCashPayments)}",
                                style: TextStyle(
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "A prazo",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalDeferredPayments)}",
                                style: TextStyle(
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
            Divider(
              color: Colors.transparent,
              height: 25,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Expense(),
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
                          FaIcon(
                            FontAwesomeIcons.arrowTrendDown,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${real.format(totalFixedExpenses + totalVariableExpense)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Gastos fixos",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalFixedExpenses)}",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Gastos variáveis",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalVariableExpense)}",
                                style: TextStyle(
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
            Divider(
              color: Colors.transparent,
              height: 20,
            ),
            ListTile(
              title: Text(
                'Pró-labore',
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
              trailing: IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.penToSquare),
              ),
            ),
            Divider(
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
              trailing: IconButton(
                onPressed: () {},
                icon: FaIcon(FontAwesomeIcons.penToSquare),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateSaldo() async {
    final form = GlobalKey<FormState>();
    final valueReservation = TextEditingController();

    AlertDialog dialog = AlertDialog(
      title: Text('Qual sua reserva financeira atual?'),
      content: Form(
        key: form,
        child: TextFormField(
          controller: valueReservation,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Informe o valor do saldo';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: Text('Salvar'),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}