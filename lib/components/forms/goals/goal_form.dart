import 'package:flutter/material.dart';
import 'package:iboss/controllers/goals/goal_controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/goals/goal_model.dart';
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
  TextEditingController finalDateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<bool> goalsCheckedList = [];
  final ptBr = const Locale('pt', 'BR');
  String goalsId = const Uuid().v1();
  double _selectedPriority = 0;

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
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                child: Text(
                  "Nova meta",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
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
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Conclui em:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(200, 40),
                ),
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
                      },
                    );
                  }
                },
                child: Text(DateFormat('dd/MM/yyyy', 'pt_BR').format(selectedDate)),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Prioridade", style: TextStyle(
                        fontSize: 20,
                      ),),
                      Row(
                        children: [
                          Container(
                            width: 200,
                            child: Slider(
                              value: _selectedPriority,
                              min: 0,
                              max: 5,
                              divisions: 5,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPriority = value;
                                });
                              },
                            ),
                          ),
                          Text(_selectedPriority.toString(), style: TextStyle(
                            fontSize: 20,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Consumer<GoalController>(
                  builder: (BuildContext context, GoalController goal,
                      Widget? widget) {
                return SizedBox(
                  width: 200,
                  height: 45,
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        GoalModel goal = GoalModel(
                          id: goalsId,
                          description: descriptionController.text,
                          finalDate: selectedDate,
                          priority: _selectedPriority,
                          isChecked: false,
                        );
                        await GoalController()
                            .addGoalToFirestore(goal);

                        // Atualize a lista de metas de negócios
                        setState(() {
                          goalsCheckedList.add(false);
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
                      'CONFIRMAR',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
