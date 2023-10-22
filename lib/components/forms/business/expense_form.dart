import 'package:flutter/material.dart';
import 'package:iboss/controllers/business/variable_expense_controller.dart';
import 'package:iboss/models/business/fixed_expense.dart';
import 'package:iboss/models/business/variable_expense.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../controllers/business/fixed_expense_controller.dart';
import '../../show_snackbar.dart';

class NewExpenseBottomSheet {
  static void show(BuildContext context,
      {FixedExpense? model1, VariableExpense? model2}) {
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
        return _BottomSheetNewExpense(
          model1: model1,
          model2: model2,
        );
      },
    );
  }
}

class _BottomSheetNewExpense extends StatefulWidget {
  final FixedExpense? model1;
  final VariableExpense? model2;

  const _BottomSheetNewExpense({this.model1, this.model2});

  @override
  __BottomSheetNewExpenseState createState() => __BottomSheetNewExpenseState();
}

class __BottomSheetNewExpenseState extends State<_BottomSheetNewExpense> {
  bool _isEditing1 = false;
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  bool _isEditing2 = false;

  @override
  void initState() {
    super.initState();
    if (widget.model1 != null) {
      descriptionController.text = widget.model1!.description;
      valueController.text = widget.model1!.value.toString();
      _isEditing1 = true;
    }
    if (widget.model2 != null) {
      descriptionController.text = widget.model2!.description;
      valueController.text = widget.model2!.value.toString();
      _isEditing2 = true;
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
              Center(
                child: Text(
                  titleText,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
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
                                  date: DateTime.now(),
                                  id: invoicingId,
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
                                  date: DateTime.now(),
                                  id: invoicingId,
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
