import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/goals/company_goals_controller.dart';
import 'package:iboss/controllers/goals/personal_goals_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iboss/models/goals/company_goals.dart';
import 'package:iboss/models/goals/personal_goals.dart';
import '../../components/drawer_component.dart';

class Goals extends StatefulWidget {
  final User user;

  const Goals({Key? key, required this.user}) : super(key: key);

  @override
  _GoalsState createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final ptBr = const Locale('pt', 'BR');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: DrawerComponent(user: widget.user),
        appBar: AppBar(
          title: const Text(
            'Metas',
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'NEGÓCIO',
              ),
              Tab(
                text: 'PESSOAL',
              ),
            ],
            indicatorColor: Color(0xFF5CE1E6),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<List<CompanyGoals>>(
                    stream: CompanyGoalsController().getCompanyGoalsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CompanyGoals>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar as metas da empresa'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma meta disponível.'),
                        );
                      } else {
                        final companyGoals = snapshot.data;
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (BuildContext context, int i) {
                            final goal = companyGoals[i];
                            final ValueNotifier<bool> companyChecked =
                                ValueNotifier<bool>(false);
                            return ValueListenableBuilder<bool>(
                              valueListenable: companyChecked,
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                  title: Text(
                                    goal.description,
                                    style: GoogleFonts.montserrat(
                                      decoration: goal.isChecked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd/MM/yyyy').format(goal.date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  secondary: IconButton(
                                    onPressed: () {
                                      showConfirmation(
                                          context: context,
                                          title:
                                              "Deseja mesmo remover essa meta do negócio?",
                                          onPressed: () async {
                                            final companyGoalsRepository =
                                                Provider.of<
                                                        CompanyGoalsController>(
                                                    context,
                                                    listen: false);
                                            await companyGoalsRepository
                                                .removeGoalsFromFirestore(
                                                    goal.id);
                                          },
                                          messegerSnack: "Meta removida",
                                          isError: false);
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: goal.isChecked,
                                  onChanged: (newValue) {
                                    CompanyGoalsController()
                                        .updateCompanyGoalStatus(
                                            goal.id, newValue!);
                                  },
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  checkColor: Colors.black,
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(
                            color: Colors.white,
                          ),
                          itemCount: companyGoals!.length,
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<PersonalGoals>>(
                    stream: PersonalGoalsController().getPersonalGoalsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PersonalGoals>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Erro ao carregar as metas pessoais'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma meta disponível.'),
                        );
                      } else {
                        final personalGoals = snapshot.data;
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (BuildContext context, int i) {
                            final goal = personalGoals[i];
                            final ValueNotifier<bool> personalChecked =
                                ValueNotifier<bool>(false);

                            return ValueListenableBuilder<bool>(
                              valueListenable: personalChecked,
                              builder: (context, value, child) {
                                return CheckboxListTile(
                                  title: Text(
                                    goal.description,
                                    style: GoogleFonts.montserrat(
                                      decoration: goal.isChecked
                                          ? TextDecoration
                                              .lineThrough // Aplicar tachado se a meta estiver marcada
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd/MM/yyyy').format(goal.date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  secondary: IconButton(
                                    onPressed: () {
                                      showConfirmation(
                                          context: context,
                                          title:
                                              "Deseja mesmo remover essa meta pessoal?",
                                          onPressed: () async {
                                            final personalGoalsRepository =
                                                Provider.of<
                                                        PersonalGoalsController>(
                                                    context,
                                                    listen: false);
                                            await personalGoalsRepository
                                                .removeGoalsFromFirestore(
                                                    goal.id);
                                          },
                                          messegerSnack: "Meta removida",
                                          isError: false);
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.trash,
                                      color: Colors.red,
                                    ),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: goal.isChecked,
                                  onChanged: (newValue) {
                                    PersonalGoalsController()
                                        .updatePerosnalGoalStatus(
                                            goal.id, newValue!);
                                  },
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  checkColor: Colors.black,
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(
                            color: Colors.white,
                          ),
                          itemCount: personalGoals!.length,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
