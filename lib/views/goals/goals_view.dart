import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/goals/goal_controller.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../components/drawer_component.dart';
import '../../components/show_confirmation.dart';
import '../../models/goals/goal_model.dart';

class GoalsView extends StatefulWidget {
  final User user;

  const GoalsView({Key? key, required this.user}) : super(key: key);

  @override
  _GoalsViewState createState() => _GoalsViewState();
}

class _GoalsViewState extends State<GoalsView> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final ptBr = const Locale('pt', 'BR');
  StreamSubscription<List<GoalModel>>? goalsStreamSubscription;

  @override
  void initState() {
    super.initState();
    goalsStreamSubscription = GoalController().getGoalsStream().listen((data) {
      // Atualizar o estado do widget com os dados
    });
  }

  @override
  void dispose() {
    // Cancelar inscrição no stream de metas da empresa quando a tela for descartada
    goalsStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: DrawerComponent(user: widget.user),
      appBar: AppBar(
        title: const Text(
          'Metas',
        ),
      ),
      body: StreamBuilder<List<GoalModel>>(
        stream: GoalController().getGoalsStream(),
        builder:
            (BuildContext context, AsyncSnapshot<List<GoalModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar as metas'),
            );
          }
          final goals = snapshot.data;
          if (goals == null || goals.isEmpty) {
            return const Center(
              child: Text('Nenhuma meta disponível.'),
            );
          }
          return ListView.separated(
            itemBuilder: (BuildContext context, int i) {
              GoalModel model = goals[i];
              return CheckboxListTile(
                title: Text(
                  goals[i].description,
                ),
                subtitle: Row(
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(goals[i].finalDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(" (${goals[i].priority})"),
                  ],
                ),
                secondary: IconButton(
                  onPressed: () {
                    showConfirmation(
                        context: context,
                        title: "Deseja mesmo remover essa meta?",
                        onPressed: () async {
                          final goalController = Provider.of<GoalController>(
                            context,
                            listen: false,
                          );
                          await goalController.removeGoalFromFirestore(
                            goals[i].id,
                          );
                        },
                        messegerSnack: "Meta removida",
                        isError: false);
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                value: goals[i].isChecked,
                onChanged: (newValue) {
                  GoalController().updateGoalStatus(
                    goals[i].id,
                    newValue!,
                  );
                },
                activeColor: Theme.of(context).colorScheme.secondary,
                checkColor: Colors.black,
              );
            },
            padding: const EdgeInsets.only(bottom: 100),
            separatorBuilder: (_, __) => const Divider(
              color: Colors.white,
            ),
            itemCount: goals.length,
          );
        },
      ),
    );
  }
}
