import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/models/personal_reservation.dart';
import 'package:iboss/repositories/personal_reservation_repository.dart';
import 'package:iboss/repositories/variable_entry_repository.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:iboss/screens/personal_screens/entry.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/fixed_entry_repository.dart';
import '../../repositories/fixed_outflow_repository.dart';
import '../../repositories/variable_expense_repository.dart';
import '../../repositories/variable_outflow_repository.dart';
import '../personal_screens/outflow.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  // variables
  TextEditingController reservationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  double totalFixedEntry = 0.0;
  double totalVariableEntry = 0.0;
  double totalFixedOutflow = 0.0;
  double totalVariableOutflow = 0.0;

  @override
  Widget build(BuildContext context) {
    final fixedEntryRepository = Provider.of<FixedEntryRepository>(context);
    totalFixedEntry =
        fixedEntryRepository.getTotalFixedEntryByMonth(_selectedDate);
    final variableEntryRepository =
    Provider.of<VariableEntryRepository>(context);
    totalVariableEntry =
        variableEntryRepository.getTotalVariableEntryByMonth(_selectedDate);

    final fixedOutflowRepository = Provider.of<FixedOutflowRepository>(context);
    totalFixedOutflow =
        fixedOutflowRepository.getTotalFixedOutflowByMonth(_selectedDate);
    final variableOutflowRepository =
    Provider.of<VariableOutflowRepository>(context);
    totalVariableOutflow =
        variableOutflowRepository.getTotalVariableOutflowByMonth(_selectedDate);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Pessoal'),
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
                    builder: (context) => Entry(),
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
                            'Entradas',
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
                        '${real.format(totalFixedEntry + totalVariableEntry)}',
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
                                "Entradas fixas",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalFixedEntry)}",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text("entradas variáveis"),
                              Text(
                                "${real.format(totalVariableEntry)}",
                                style: TextStyle(color: Colors.green),
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
              height: 35,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Outflow(),
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
                            'Saídas',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          FaIcon(
                            FontAwesomeIcons.arrowTrendDown,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Total',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        '${real.format(totalFixedOutflow + totalVariableOutflow)}',
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
                                "Saídas fixas",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalFixedOutflow)}",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Saídas variáveis",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                "${real.format(totalVariableOutflow)}",
                                style: TextStyle(color: Colors.red),
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
              height: 35,
            ),
            ListTile(
              title: Text('Reserva de emergência'),
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
}