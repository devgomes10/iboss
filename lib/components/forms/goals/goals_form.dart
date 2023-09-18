import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/models/goals/personal_goals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/goals/company_goals.dart';
import '../../../repositories/goals/company_goals_repository.dart';
import '../../../repositories/goals/personal_goals_repository.dart';
import '../../snackbar/show_snackbar.dart';

class NewGoal {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DialogNewGoal();
      },
    );
  }
}

class _DialogNewGoal extends StatefulWidget {
  @override
  ___DialogNewGoalState createState() => ___DialogNewGoalState();
}

class ___DialogNewGoalState extends State<_DialogNewGoal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool checked = false;
  DateTime selectedDate = DateTime.now();
  List<bool> companyCheckedList = [];
  List<bool> personalCheckedList = [];
  final ptBr = const Locale('pt', 'BR');
  String goalsId = const Uuid().v1();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        'Crie uma meta e adicione uma data de conclusão',
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
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          locale: ptBr,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        );
                        if (dateTime != null) {
                          setState(() {
                            selectedDate = dateTime;
                            dateController.text =
                                DateFormat('dd/MM/yyyy', 'pt_BR')
                                    .format(selectedDate);
                          });
                        }
                      },
                      icon: const FaIcon(FontAwesomeIcons.calendar),
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
              'É uma meta para o empreendimento ou pessoal?',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<CompanyGoalsRepository>(builder:
                      (BuildContext context, CompanyGoalsRepository forCompany,
                          Widget? widget) {
                    return SizedBox(
                      width: 140,
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CompanyGoals company = CompanyGoals(
                              description: descriptionController.text,
                              date: DateTime.now(),
                              id: goalsId,
                            );
                            await forCompany
                                .addCompanyGoalsToFirestore(company);
                            showSnackbar(
                                context: context,
                                isError: false,
                                menssager: "Meta adicionada");
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Empreendimento',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                  Consumer<PersonalGoalsRepository>(builder:
                      (BuildContext context,
                          PersonalGoalsRepository forPersonal, Widget? widget) {
                    return SizedBox(
                      width: 140,
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            PersonalGoals personal = PersonalGoals(
                              description: descriptionController.text,
                              date: DateTime.now(),
                              id: goalsId,
                            );
                            await forPersonal
                                .addPersonalGoalsToFirestore(personal);
                            showSnackbar(
                                context: context,
                                isError: false,
                                menssager: "Meta adicionada");
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Pessoal',
                          style: TextStyle(
                            color: Colors.white,
                          ),
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
    );
  }
}
