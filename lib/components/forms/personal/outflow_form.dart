import 'package:flutter/material.dart';
import 'package:iboss/models/personal/fixed_outflow.dart';
import 'package:iboss/models/personal/variable_outflow.dart';
import 'package:iboss/repositories/personal/fixed_outflow_repository.dart';
import 'package:iboss/repositories/personal/variable_outflow_repository.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../show_snackbar.dart';

class NewOutflowBottomSheet {
  static void show(BuildContext context,
      {FixedOutflow? model1, VariableOutflow? model2}) {
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
        return _BottomSheetNewOutflow(
          model1: model1,
          model2: model2,
        );
      },
    );
  }
}

class _BottomSheetNewOutflow extends StatefulWidget {
  final FixedOutflow? model1;
  final VariableOutflow? model2;

  const _BottomSheetNewOutflow({this.model1, this.model2});

  @override
  __BottomSheetNewOutflowState createState() => __BottomSheetNewOutflowState();
}

class __BottomSheetNewOutflowState extends State<_BottomSheetNewOutflow> {
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
    final fixedOutflowModel = widget.model1;
    final variableOutflowModel = widget.model2;
    final titleText = _isEditing1 || _isEditing2
        ? "Editando gasto"
        : "Adicione um novo gasto";
    final buttonText1 = _isEditing1 ? "Confirmar" : "FIXO";
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
                    'É um gasto fixo ou variável?',
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
                    Consumer<FixedOutflowRepository>(
                      builder: (BuildContext context,
                          FixedOutflowRepository fixed, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FixedOutflow fixed = FixedOutflow(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );

                                if (fixedOutflowModel != null) {
                                  fixed.id = fixedOutflowModel.id;
                                }

                                await FixedOutflowRepository()
                                    .addOutflowToFirestore(fixed);

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Gasto adicionado");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Gasto editado");
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
                    Consumer<VariableOutflowRepository>(
                      builder: (BuildContext context,
                          VariableOutflowRepository variable, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                VariableOutflow variable = VariableOutflow(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );

                                if (variableOutflowModel != null) {
                                  variable.id = variableOutflowModel.id;
                                }

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Gasto adicionado");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Gasto editado");
                                }

                                await VariableOutflowRepository()
                                    .addOutflowToFirestore(variable);
                                showSnackbar(
                                    context: context,
                                    isError: false,
                                    menssager: "Gasto adicionado");
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
