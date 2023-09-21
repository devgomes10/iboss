import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/personal/fixed_outflow.dart';
import '../../../models/personal/variable_outflow.dart';
import '../../../repositories/personal/fixed_outflow_repository.dart';
import '../../../repositories/personal/variable_outflow_repository.dart';
import '../../snackbar/show_snackbar.dart';

class NewOutflowBottomSheet {
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
        return _BottomSheetNewOutflow();
      },
    );
  }
}

class _BottomSheetNewOutflow extends StatefulWidget {
  @override
  __BottomSheetNewOutflowState createState() => __BottomSheetNewOutflowState();
}

class __BottomSheetNewOutflowState extends State<_BottomSheetNewOutflow> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  String invoicingId = const Uuid().v1();

  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    valueFocusNode.dispose();
    super.dispose();
  }

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
              Center(
                child: Text(
                  "Adicione um novo gasto",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
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
                  Consumer<FixedOutflowRepository>(
                    builder: (BuildContext context,
                        FixedOutflowRepository fixed, Widget? widget) {
                      return SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              FixedOutflow fixedOuflow = FixedOutflow(
                                description: descriptionController.text,
                                value: double.parse(valueController.text),
                                date: DateTime.now(),
                                id: invoicingId,
                              );
                              await FixedOutflowRepository()
                                  .addOutflowToFirestore(fixedOuflow);
                              showSnackbar(
                                  context: context,
                                  isError: false,
                                  menssager: "Gasto adicionado");
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                          child: const Text(
                            'Fixo',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Consumer<VariableOutflowRepository>(
                    builder: (BuildContext context,
                        VariableOutflowRepository variable, Widget? widget) {
                      return SizedBox(
                        width: 100,
                        child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              VariableOutflow variableOutflow = VariableOutflow(
                                description: descriptionController.text,
                                value: double.parse(valueController.text),
                                date: DateTime.now(),
                                id: invoicingId,
                              );
                              await VariableOutflowRepository()
                                  .addOutflowToFirestore(variableOutflow);
                              showSnackbar(
                                  context: context,
                                  isError: false,
                                  menssager: "Gasto adicionado");
                              Navigator.pop(context);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                          ),
                          child: const Text(
                            'Variável',
                            style: TextStyle(
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
