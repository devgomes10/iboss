import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../repositories/personal/fixed_entry_repository.dart';
import '../../repositories/personal/fixed_outflow_repository.dart';
import '../../repositories/personal/variable_entry_repository.dart';
import '../../repositories/personal/variable_outflow_repository.dart';
import 'entry.dart';
import 'outflow.dart';

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  // variables
  TextEditingController reservationController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
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
                    builder: (context) => const Entry(),
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
                      Text(
                        real.format(totalFixedEntry + totalVariableEntry),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                                real.format(totalFixedEntry),
                                style: const TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text("entradas variáveis"),
                              Text(
                                real.format(totalVariableEntry),
                                style: const TextStyle(color: Colors.green),
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
              height: 35,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Outflow(),
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
                          const FaIcon(
                            FontAwesomeIcons.arrowTrendDown,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Total',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        real.format(totalFixedOutflow + totalVariableOutflow),
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
                                "Saídas fixas",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                real.format(totalFixedOutflow),
                                style: const TextStyle(color: Colors.red),
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
                                real.format(totalVariableOutflow),
                                style: const TextStyle(color: Colors.red),
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
              height: 35,
            ),
            ListTile(
              title: const Text('Reserva de emergência'),
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
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.penToSquare),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.circleInfo),
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