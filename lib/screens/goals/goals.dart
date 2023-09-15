import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/models/goals/personal_goals.dart';
import 'package:iboss/repositories/goals/personal_goals_repository.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/goals/company_goals.dart';
import '../../repositories/goals/company_goals_repository.dart';

class Goals extends StatefulWidget {
  final User user;

  const Goals({super.key, required this.user});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool checked = false;
  DateTime selectedDate = DateTime.now();
  List<bool> companyCheckedList = [];
  List<bool> personalCheckedList = [];
  final ptBr = const Locale('pt', 'BR');

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Metas financeiras',
          ),
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
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.industry),
                text: 'Empresa',
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.userLarge),
                text: 'Pessoal',
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
                        return CircularProgressIndicator(); // Você pode usar um indicador de carregamento enquanto os dados são carregados.
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Nenhuma meta disponível.'),
                        );
                      } else {
                        final companyGoals = snapshot.data;
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (BuildContext context, int i) {
                            if (i >= companyCheckedList.length) {
                              companyCheckedList.add(false);
                            }
                            final goal = companyGoals[i];
                            return CheckboxListTile(
                              title: Text(
                                goal.description,
                                style: GoogleFonts.montserrat(
                                  decoration: companyCheckedList[i]
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      scrollable: true,
                                      title: const Text(
                                        'Deseja excluir essa meta?',
                                      ),
                                      content: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[400],
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                child: const Text('NÃO'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  final companyGoalsRepository =
                                                      Provider.of<
                                                              CompanyGoalsRepository>(
                                                          context,
                                                          listen: false);
                                                  await companyGoalsRepository
                                                      .removeGoalsFromFirestore(
                                                          goal.id);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Meta removida',
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey[400],
                                                  textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                child: const Text(
                                                  'EXCLUIR',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: companyCheckedList[i],
                              onChanged: (value) {
                                setState(() {
                                  companyCheckedList[i] = value!;
                                });
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.black,
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
                    stream: PersonalGoalsRepository().getPersonalGoalsStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PersonalGoals>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Você pode usar um indicador de carregamento enquanto os dados são carregados.
                      } else if (snapshot.hasError) {
                        return Text('Erro: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('Nenhuma meta disponível.'),
                        );
                      } else {
                        final personalGoals = snapshot.data;
                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (BuildContext context, int i) {
                            if (i >= personalCheckedList.length) {
                              personalCheckedList.add(false);
                            }
                            final goal = personalGoals[i];
                            return CheckboxListTile(
                              title: Text(
                                goal.description,
                                style: GoogleFonts.montserrat(
                                  decoration: personalCheckedList[i]
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
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          scrollable: true,
                                          title: const Text(
                                            'Deseja excluir essa meta?',
                                          ),
                                          content: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      Colors.grey[400],
                                                      textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    child: const Text('NÃO'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      final personalGoalsRepository =
                                                      Provider.of<
                                                          PersonalGoalsRepository>(
                                                          context,
                                                          listen: false);
                                                      await personalGoalsRepository
                                                          .removeGoalsFromFirestore(
                                                          goal.id);
                                                      ScaffoldMessenger.of(context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Meta removida',
                                                          ),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                      Colors.grey[400],
                                                      textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      'EXCLUIR',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                                icon: const FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: personalCheckedList[i],
                              onChanged: (value) {
                                setState(() {
                                  personalCheckedList[i] = value!;
                                });
                              },
                              activeColor: Colors.green,
                              checkColor: Colors.black,
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
