import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/show_confirmation_password.dart';
import '../../repositories/authentication/auth_service.dart';
import '../../repositories/personal/fixed_entry_repository.dart';
import '../../repositories/personal/fixed_outflow_repository.dart';
import '../../repositories/personal/variable_entry_repository.dart';
import '../../repositories/personal/variable_outflow_repository.dart';
import '../financial_education/financial_education.dart';
import 'entry.dart';
import 'outflow.dart';

class Personal extends StatefulWidget {
  final User user;

  const Personal({super.key, required this.user});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  // variables
  TextEditingController emergencyController = TextEditingController();
  TextEditingController opportunityController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  double totalFixedEntry = 0.0;
  double totalVariableEntry = 0.0;
  double totalFixedOutflow = 0.0;
  double totalVariableOutflow = 0.0;

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Pessoal'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FinancialEducation(),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.graduationCap)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, right: 7, bottom: 10, left: 7),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Entry(),
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
                              'Renda',
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
                            FixedEntryRepository()
                                .getTotalFixedEntryByMonth(_selectedDate),
                            VariableEntryRepository()
                                .getTotalVariableEntryByMonth(_selectedDate),
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
                                  color: Colors.green,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text('erro...');
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
                                  stream: FixedEntryRepository()
                                      .getTotalFixedEntryByMonth(_selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalFixedEntry = snapshot.data;
                                      return Text(
                                        real.format(totalFixedEntry),
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("erro...");
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
                                  stream: VariableEntryRepository()
                                      .getTotalVariableEntryByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalVariableEntry = snapshot.data;
                                      return Text(
                                        real.format(totalVariableEntry),
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("erro...");
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
              height: 20,
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
                              'Gastos',
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
                        StreamBuilder<double>(
                          stream: CombineLatestStream.combine2(
                            FixedOutflowRepository()
                                .getTotalFixedOutflowByMonth(_selectedDate),
                            VariableOutflowRepository()
                                .getTotalVariableOutflowByMonth(_selectedDate),
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
                              return const Text('erro...');
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
                                  "Fixos",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                StreamBuilder<double>(
                                  stream: FixedOutflowRepository()
                                      .getTotalFixedOutflowByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalFixedOutflow = snapshot.data;
                                      return Text(
                                        real.format(totalFixedOutflow),
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("erro...");
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
                                  stream: VariableOutflowRepository()
                                      .getTotalVariableOutflowByMonth(
                                          _selectedDate),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double> snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      final totalVariableOutflow =
                                          snapshot.data;
                                      return Text(
                                        real.format(totalVariableOutflow),
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Text("erro...");
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
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
