import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TransactionForm {
  final String title;
  final String classification;
  final Consumer consumer1;
  final Consumer consumer2;

  TransactionForm({
    required this.title,
    required this.classification,
    required this.consumer1,
    required this.consumer2,
  });

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController descriptionController =
  TextEditingController();
  static final TextEditingController valueController = TextEditingController();
  static String invoicingId = const Uuid().v1();
  static final FocusNode descriptionFocusNode = FocusNode();
  static final FocusNode valueFocusNode = FocusNode();

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
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
                      title,
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
                  Center(
                    child: Text(
                      classification,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Consumer> [
                      consumer1,
                      consumer2,
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
