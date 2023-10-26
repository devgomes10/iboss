import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../controllers/business/fixed_expense_controller.dart';
import '../controllers/business/variable_expense_controller.dart';
import '../models/business/fixed_expense.dart';
import '../models/business/variable_expense.dart';

class Test extends StatefulWidget {
  final FixedExpense? model1;
  final VariableExpense? model2;

  const Test({super.key, this.model1, this.model2});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isExpensePaid = false;
  bool _isEditing1 = false;
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  bool _isEditing2 = false;
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.model1 != null) {
      if (widget.model1 is FixedExpense) {
        isExpensePaid = (widget.model1 as FixedExpense).isPaid;
      }
      descriptionController.text = widget.model1!.description;
      valueController.text = widget.model1!.value.toString();
      _isEditing1 = true;
      date = widget.model1!.date;
    }
    if (widget.model2 != null) {
      if (widget.model2 is VariableExpense) {
        isExpensePaid = (widget.model2 as VariableExpense).isPaid;
      }
      descriptionController.text = widget.model2!.description;
      valueController.text = widget.model2!.value.toString();
      _isEditing2 = true;
      date = widget.model2!.date;
    }
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    valueFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fixedExpenseModel = widget.model1;
    final variableExpenseModel = widget.model2;
    final titleText = _isEditing1 || _isEditing2
        ? "Editando despesa"
        : "Adicione uma nova despesa";
    final buttonText1 = _isEditing1 ? "Confirmar" : "FIXA";
    final buttonText2 = _isEditing2 ? "Confirmar" : "VARIÁVEL";

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Insira uma descrição";
                  }
                  if (value.length > 80) {
                    return "Descrição muito grande";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: descriptionController,
                focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira um valor";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: valueController,
                focusNode: valueFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Está pago?", style: GoogleFonts.raleway(
                    fontSize: 20,
                  ),),
                  Switch(
                    value: isExpensePaid,
                    onChanged: (newValue) async {
                      setState(() {
                        isExpensePaid = newValue;
                      });
                      final fixedExpenses = await FixedExpenseController()
                          .getFixedExpensesFromFirestore();
                      final variableExpenses = await VariableExpenseController()
                          .getVariableExpensesFromFirestore();
                      if (fixedExpenses.isNotEmpty) {
                        final firstExpense = fixedExpenses.first;
                        FixedExpenseController().updateFixedExpenseStatus(
                            firstExpense.id, newValue);
                      }
                      if (variableExpenses.isNotEmpty) {
                        final firstExpense = variableExpenses.first;
                        VariableExpenseController().updateVariableExpenseStatus(
                            firstExpense.id, newValue);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!_isEditing1 && !_isEditing2)
                const Center(
                  child: Text(
                    'É uma despesa fixa ou variável?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (!_isEditing2)
                    Consumer<FixedExpenseController>(
                      builder: (BuildContext context,
                          FixedExpenseController fixed, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FixedExpense fixed = FixedExpense(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: date,
                                  id: invoicingId,
                                  isPaid: isExpensePaid,
                                );

                                if (fixedExpenseModel != null) {
                                  fixed.id = fixedExpenseModel.id;
                                }
                                await FixedExpenseController()
                                    .addExpenseToFirestore(fixed);

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Despesa adicionada");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Despesa editada");
                                }

                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF5CE1E6),
                            ),
                            child: Text(
                              buttonText1,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (!_isEditing1)
                    Consumer<VariableExpenseController>(
                      builder: (BuildContext context,
                          VariableExpenseController variable, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                VariableExpense variable = VariableExpense(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: date,
                                  id: invoicingId,
                                  isPaid: isExpensePaid,
                                );

                                if (variableExpenseModel != null) {
                                  variable.id = variableExpenseModel.id;
                                }

                                await VariableExpenseController()
                                    .addExpenseToFirestore(variable);

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Despesa adicionada");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Despesa editada");
                                }
                                Navigator.pop(context);
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF5CE1E6),
                            ),
                            child: Text(
                              buttonText2,
                              style: const TextStyle(
                                fontSize: 16,
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
