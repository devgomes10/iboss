import 'package:flutter/material.dart';
import 'package:iboss/controllers/personal/fixed_entry_controller.dart';
import 'package:iboss/controllers/personal/variable_entry_controller.dart';
import 'package:iboss/models/personal/fixed_entry.dart';
import 'package:iboss/models/personal/variable_entry.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../show_snackbar.dart';

class NewEntryBottomSheet {
  static void show(BuildContext context,
      {FixedEntry? model1, VariableEntry? model2}) {
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
        return _BottomSheetNewEntry(
          model1: model1,
          model2: model2,
        );
      },
    );
  }
}

class _BottomSheetNewEntry extends StatefulWidget {
  final FixedEntry? model1;
  final VariableEntry? model2;

  const _BottomSheetNewEntry({this.model1, this.model2});

  @override
  __BottomSheetNewEntryState createState() => __BottomSheetNewEntryState();
}

class __BottomSheetNewEntryState extends State<_BottomSheetNewEntry> {
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
    final fixedEntryModel = widget.model1;
    final variableEntryModel = widget.model2;
    final titleText = _isEditing1 || _isEditing2
        ? "Editando renda"
        : "Adicione uma nova renda";
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
                    'É uma renda fixa ou variável?',
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
                    Consumer<FixedEntryController>(
                      builder: (BuildContext context,
                          FixedEntryController fixed, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                FixedEntry fixed = FixedEntry(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );

                                if (fixedEntryModel != null) {
                                  fixed.id = fixedEntryModel.id;
                                }

                                await FixedEntryController()
                                    .addEntryToFirestore(fixed);

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Renda adicionada");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Renda editada");
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
                    Consumer<VariableEntryController>(
                      builder: (BuildContext context,
                          VariableEntryController variable, Widget? widget) {
                        return SizedBox(
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                VariableEntry variable = VariableEntry(
                                  description: descriptionController.text,
                                  value: double.parse(valueController.text),
                                  date: DateTime.now(),
                                  id: invoicingId,
                                );

                                if (variableEntryModel != null) {
                                  variable.id = variableEntryModel.id;
                                }

                                await VariableEntryController()
                                    .addEntryToFirestore(variable);

                                if (!_isEditing1 && !_isEditing2) {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Renda adicionada");
                                } else {
                                  showSnackbar(
                                      context: context,
                                      isError: false,
                                      menssager: "Renda editada");
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
