import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/models/company_goals.dart';
import 'package:iboss/models/personal_goals.dart';
import 'package:iboss/repositories/company_goals_repository.dart';
import 'package:iboss/repositories/personal_goals_repository.dart';
import 'package:iboss/screens/main_screens/settings.dart';
import 'package:provider/provider.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text(
            'Metas financeiras',
          ),
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
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
            )
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                scrollable: true,
                title: const Text('Din Din'),
                content: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(hintText: 'Descrição'),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                final DateTime? dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(3000),
                                );
                                if (DateTime != null) {
                                  setState(() {
                                    selectedDate = dateTime!;
                                  });
                                }
                              },
                              child: const Text('Data de conclusão')),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: Column(
                      children: [
                        const Text('É uma meta para a empresa ou pessoal?'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<CompanyGoalsRepository>(builder:
                                  (BuildContext context,
                                      CompanyGoalsRepository forCompany,
                                      Widget? widget) {
                                return TextButton(
                                  onPressed: () {
                                    forCompany.add(CompanyGoals(
                                        description: descriptionController.text,
                                        date:
                                            "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}"));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Criando uma nova Meta'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Empresa'),
                                );
                              }),
                              Consumer<PersonalGoalsRepository>(builder:
                                  (BuildContext context,
                                      PersonalGoalsRepository forPersonal,
                                      Widget? widget) {
                                return TextButton(
                                  onPressed: () {
                                    forPersonal.add(PersonalGoals(
                                        description: descriptionController.text,
                                        date:
                                            "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}"));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Criando uma nova Meta'),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Pessoal'),
                                );
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            Consumer<CompanyGoalsRepository>(
              builder: (BuildContext context, CompanyGoalsRepository forCompany,
                  Widget? widget) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    // Check if the index is within the bounds of the checked list
                    if (i >= companyCheckedList.length) {
                      companyCheckedList.add(false);
                    }
                    return CheckboxListTile(
                      title: Text(forCompany.companyGoals[i].description),
                      secondary:
                          Text(forCompany.companyGoals[i].date.toString()),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: companyCheckedList[i],
                      // Use the appropriate checked value
                      onChanged: (value) {
                        setState(() {
                          companyCheckedList[i] = value!;
                        });
                      },
                      activeColor: Colors.red,
                      checkColor: Colors.black,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: forCompany.companyGoals.length,
                );
              },
            ),
            Consumer<PersonalGoalsRepository>(
              builder: (BuildContext context,
                  PersonalGoalsRepository forPersonal, Widget? widget) {
                return ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    // Check if the index is within the bounds of the checked list
                    if (i >= personalCheckedList.length) {
                      personalCheckedList.add(false);
                    }
                    return CheckboxListTile(
                      title: Text(forPersonal.personalGoals[i].description),
                      secondary:
                          Text(forPersonal.personalGoals[i].date.toString()),
                      controlAffinity: ListTileControlAffinity.leading,
                      value: personalCheckedList[i],
                      // Use the appropriate checked value
                      onChanged: (value) {
                        setState(() {
                          personalCheckedList[i] = value!;
                        });
                      },
                      activeColor: Colors.green,
                      checkColor: Colors.black,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: forPersonal.personalGoals.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
