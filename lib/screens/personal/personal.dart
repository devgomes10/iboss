import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/box_card.dart';
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
  final DateTime _selectedDate = DateTime.now();

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, right: 7, bottom: 10, left: 7),
        child: Column(
          children: [
            BoxCard(
              title: "Renda",
              streamTotal: CombineLatestStream.combine2(
                FixedEntryRepository().getTotalFixedEntryByMonth(_selectedDate),
                VariableEntryRepository()
                    .getTotalVariableEntryByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedEntryRepository()
                  .getTotalFixedEntryByMonth(_selectedDate),
              stream2: VariableEntryRepository()
                  .getTotalVariableEntryByMonth(_selectedDate),
              screen: const Entry(),
              color: Colors.green,
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            BoxCard(
              title: "Gastos",
              streamTotal: CombineLatestStream.combine2(
                FixedOutflowRepository()
                    .getTotalFixedOutflowByMonth(_selectedDate),
                VariableOutflowRepository()
                    .getTotalVariableOutflowByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedOutflowRepository()
                  .getTotalFixedOutflowByMonth(_selectedDate),
              stream2: VariableOutflowRepository()
                  .getTotalVariableOutflowByMonth(_selectedDate),
              screen: const Outflow(),
              color: Colors.red,
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
