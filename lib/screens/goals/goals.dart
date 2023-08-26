import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/models/goals/company_goals.dart';
import 'package:iboss/repositories/goals/personal_goals_repository.dart';
import 'package:iboss/screens/settings/settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/goals/personal_goals.dart';
import '../../repositories/goals/company_goals_repository.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final _formKey = GlobalKey<FormState>();
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        scrollable: true,
                        title: Text(
                          'Adicione uma nova meta',
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return "Insira uma descrição";
                                            }
                                            return null;
                                          },
                                          controller: descriptionController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            labelText: 'Descrição',
                                            hintText: 'Descrição...',
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final DateTime? dateTime =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: selectedDate,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000),
                                          );

                                          if (dateTime != null) {
                                            setState(() {
                                              selectedDate = dateTime;
                                              dateController.text = DateFormat(
                                                      'dd/MM/yyyy', 'pt_BR')
                                                  .format(selectedDate);
                                            });
                                          }
                                        },
                                        icon: const FaIcon(
                                            FontAwesomeIcons.calendar),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          Column(
                            children: [
                              const Text(
                                'É uma meta para a empresa ou pessoal?',
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, bottom: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Consumer<CompanyGoalsRepository>(builder:
                                        (BuildContext context,
                                            CompanyGoalsRepository forCompany,
                                            Widget? widget) {
                                      return SizedBox(
                                        width: 85,
                                        height: 45,
                                        child: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              forCompany.add(
                                                CompanyGoals(
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  date:
                                                      "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}",
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Criando uma nova Meta',
                                                  ),
                                                ),
                                              );
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[400],
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          child: const Text(
                                            'Empresa',
                                          ),
                                        ),
                                      );
                                    }),
                                    Consumer<PersonalGoalsRepository>(builder:
                                        (BuildContext context,
                                            PersonalGoalsRepository forPersonal,
                                            Widget? widget) {
                                      return SizedBox(
                                        width: 85,
                                        height: 45,
                                        child: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              forPersonal.add(PersonalGoals(
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  date:
                                                      "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}"));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Criando uma nova Meta',
                                                  ),
                                                ),
                                              );
                                              Navigator.pop(context);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey[400],
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          child: const Text(
                                            'Pessoal',
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Nova meta',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Consumer<CompanyGoalsRepository>(
                    builder: (BuildContext context,
                        CompanyGoalsRepository forCompany, Widget? widget) {
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (BuildContext context, int i) {
                          if (i >= companyCheckedList.length) {
                            companyCheckedList.add(false);
                          }
                          return CheckboxListTile(
                            title: Text(
                              forCompany.companyGoals[i].description,
                              style: GoogleFonts.montserrat(
                                decoration: companyCheckedList[i]
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              forCompany.companyGoals[i].date,
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
                                              child: const Text('Não'),
                                            ),
                                            Consumer<CompanyGoalsRepository>(
                                              builder: (BuildContext context,
                                                  CompanyGoalsRepository goal,
                                                  Widget? widget) {
                                                return TextButton(
                                                  onPressed: () async {
                                                    goal.remove(i);
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                    'Sim',
                                                  ),
                                                );
                                              },
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
                        itemCount: forCompany.companyGoals.length,
                      );
                    },
                  ),
                  Consumer<PersonalGoalsRepository>(
                    builder: (BuildContext context,
                        PersonalGoalsRepository forPersonal, Widget? widget) {
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemBuilder: (BuildContext context, int i) {
                          if (i >= personalCheckedList.length) {
                            personalCheckedList.add(false);
                          }
                          return CheckboxListTile(
                            title: Text(
                              forPersonal.personalGoals[i].description,
                              style: GoogleFonts.montserrat(
                                decoration: personalCheckedList[i]
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              forPersonal.personalGoals[i].date.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            secondary: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    scrollable: true,
                                    title:
                                        const Text('Deseja excluir essa meta?'),
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
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[400],
                                                textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              child: const Text('Não'),
                                            ),
                                            Consumer<PersonalGoalsRepository>(
                                              builder: (BuildContext context,
                                                  PersonalGoalsRepository goal,
                                                  Widget? widget) {
                                                return TextButton(
                                                  onPressed: () async {
                                                    goal.remove(i);
                                                    ScaffoldMessenger.of(
                                                            context)
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
                                                    'Sim',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              },
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
                        itemCount: forPersonal.personalGoals.length,
                      );
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
