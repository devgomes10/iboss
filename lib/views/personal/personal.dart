import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iboss/components/box_card.dart';
import 'package:iboss/controllers/personal/fixed_entry_controller.dart';
import 'package:iboss/controllers/personal/fixed_outflow_controller.dart';
import 'package:iboss/controllers/personal/variable_entry_controller.dart';
import 'package:iboss/controllers/personal/variable_outflow_controller.dart';
import 'package:rxdart/rxdart.dart';
import '../../components/drawer_component.dart';
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
      drawer: DrawerComponent(user: widget.user),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Pessoal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 20,
          right: 7,
          bottom: 10,
          left: 7,
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            BoxCard(
              title: "Renda",
              streamTotal: CombineLatestStream.combine2(
                FixedEntryController().getTotalFixedEntryByMonth(_selectedDate),
                VariableEntryController()
                    .getTotalVariableEntryByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedEntryController()
                  .getTotalFixedEntryByMonth(_selectedDate),
              stream2: VariableEntryController()
                  .getTotalVariableEntryByMonth(_selectedDate),
              screen: const Entry(),
              color: Colors.green,
            ),
            const Divider(
              color: Colors.transparent,
              height: 50,
            ),
            BoxCard(
              title: "Gastos",
              streamTotal: CombineLatestStream.combine2(
                FixedOutflowController()
                    .getTotalFixedOutflowByMonth(_selectedDate),
                VariableOutflowController()
                    .getTotalVariableOutflowByMonth(_selectedDate),
                (double totalFixed, double totalVariable) =>
                    totalFixed + totalVariable,
              ),
              stream1: FixedOutflowController()
                  .getTotalFixedOutflowByMonth(_selectedDate),
              stream2: VariableOutflowController()
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
