import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/goals/company_goals_controller.dart';
import 'package:iboss/controllers/goals/personal_goals_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/goals/company_goals.dart';
import '../../../models/goals/personal_goals.dart';
import '../../show_snackbar.dart';

class NewGoalBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return _BottomSheetNewGoal();
      },
    );
  }
}

class _BottomSheetNewGoal extends StatefulWidget {
  @override
  __BottomSheetNewGoalState createState() => __BottomSheetNewGoalState();
}

class __BottomSheetNewGoalState extends State<_BottomSheetNewGoal> {
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
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                child: Text(
                  "Adicione uma meta e uma data de conclusão",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                        setState(
                          () {
                            selectedDate = dateTime;
                            dateController.text =
                                DateFormat('dd/MM/yyyy', 'pt_BR')
                                    .format(selectedDate);
                          },
                        );
                      }
                    },
                    icon: const FaIcon(FontAwesomeIcons.calendar),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'É uma meta do negócio ou pessoal?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<CompanyGoalsController>(builder:
                      (BuildContext context, CompanyGoalsController forCompany,
                          Widget? widget) {
                    return SizedBox(
                      width: 140,
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            CompanyGoals company = CompanyGoals(
                              description: descriptionController.text,
                              date: selectedDate,
                              id: goalsId,
                              isChecked: false,
                            );
                            await CompanyGoalsController()
                                .addCompanyGoalsToFirestore(company);

                            // Atualize a lista de metas de negócios
                            setState(() {
                              companyCheckedList.add(false);
                            });

                            showSnackbar(
                              context: context,
                              isError: false,
                              menssager: "Meta adicionada",
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF5CE1E6),
                        ),
                        child: const Text(
                          'NEGÓCIO',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                  Consumer<PersonalGoalsController>(
                    builder: (BuildContext context,
                        PersonalGoalsController forPersonal, Widget? widget) {
                      return SizedBox(
                        width: 140,
                        height: 45,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              PersonalGoals personal = PersonalGoals(
                                description: descriptionController.text,
                                date: selectedDate,
                                id: goalsId,
                                isChecked: false,
                              );
                              await PersonalGoalsController()
                                  .addPersonalGoalsToFirestore(personal);
                              showSnackbar(
                                  context: context,
                                  isError: false,
                                  menssager: "Meta adicionada");
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF5CE1E6),
                          ),
                          child: const Text(
                            'PESSOAL',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
