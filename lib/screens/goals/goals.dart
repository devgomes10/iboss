import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iboss/models/goals/company_goals.dart';
import 'package:iboss/models/goals/personal_goals.dart';
import 'package:iboss/repositories/authentication/auth_service.dart';
import 'package:iboss/repositories/goals/company_goals_repository.dart';
import 'package:iboss/repositories/goals/personal_goals_repository.dart';

import '../../components/drawer_component.dart';
import '../../components/show_confirmation_password.dart';

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
        drawer: DrawerComponent(user: widget.user),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .background,
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .primary,
          title: const Text(
            'Metas',
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.industry),
                text: 'NEGÓCIO',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.userLarge),
                text: 'PESSOAL',
              ),
            ],
            indicatorColor: Colors.white,
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
                    stream: CompanyGoalsRepository().getCompanyGoalsStream(),
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
                                      decoration: value
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat('dd/MM/yyyy').format(goal.date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  secondary: IconButton(
                                    onPressed: () {
                                      showConfirmation(context: context,
                                          title: "Deseja mesmo remover essa meta do negócio?",
                                          onPressed: () async {
                                            final companyGoalsRepository =
                                            Provider.of<
                                                CompanyGoalsRepository>(
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
                                  value: value,
                                  onChanged: (newValue) {
                                    companyChecked.value = newValue!;
                                  },
                                  activeColor: Colors.green,
                                  checkColor: Colors.black,
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                          const Divider(
                            color: Colors.white,
                          ),
                          itemCount: companyGoals!.length,
                        );
                      }
                    },
                  ),
                  StreamBuilder<List<PersonalGoals>>(
                    stream: PersonalGoalsRepository().getPersonalGoalsStream(),
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
                                      decoration: value
                                          ? TextDecoration.lineThrough
                                          : null,
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
                                          title: "Deseja mesmo remover essa meta pessoal?",
                                          onPressed: () async {
                                            final personalGoalsRepository =
                                            Provider.of<
                                                PersonalGoalsRepository>(
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
                                  value: value,
                                  onChanged: (newValue) {
                                    personalChecked.value = newValue!;
                                  },
                                  activeColor: Colors.green,
                                  checkColor: Colors.black,
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                          const Divider(
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
