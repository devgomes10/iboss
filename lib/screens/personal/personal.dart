import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/repositories/personal/opportunity_reserve_repository.dart';
import 'package:iboss/repositories/personal/personal_reservation_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/show_confirmation_password.dart';
import '../../repositories/authentication/auth_service.dart';
import '../../repositories/personal/fixed_entry_repository.dart';
import '../../repositories/personal/fixed_outflow_repository.dart';
import '../../repositories/personal/variable_entry_repository.dart';
import '../../repositories/personal/variable_outflow_repository.dart';
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
    final opportunityReserve =
        Provider.of<OpportunityReserveRepository>(context);
    final emergencyReserve =
        Provider.of<PersonalReservationRepository>(context);
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
                'Reserva de emergência',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: FutureBuilder<double?>(
                future: emergencyReserve.getCurrentPersonalReservation(),
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
                    final emergencyValue = snapshot.data!;
                    return Text(
                      real.format(emergencyValue),
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
                              'Qual a sua reserva de emergência atual?',
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
                                        controller: emergencyController,
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
                                                  final newEmergency =
                                                      double.tryParse(
                                                              emergencyController
                                                                  .text) ??
                                                          0.0;
                                                  emergencyReserve
                                                      .updatePersonalReservation(
                                                          newEmergency);

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
                'Reserva de Oportunidade',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: FutureBuilder<double?>(
                future: opportunityReserve.getCurrentOpportunityReserve(),
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
                    final opportunityValue = snapshot.data!;
                    return Text(
                      real.format(opportunityValue),
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
                              'Qual é sua reserva de oportunidade atual?',
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
                                        controller: opportunityController,
                                        decoration: const InputDecoration(
                                          labelText: 'Reserva de oportunidade',
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
                                                  final newOpportunity =
                                                      double.tryParse(
                                                          opportunityController
                                                              .text) ??
                                                          0.0;
                                                  opportunityReserve
                                                      .updateOpportunityReserve(newOpportunity);

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
