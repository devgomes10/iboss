import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../models/business/fixed_expense.dart';
import '../../../models/business/variable_expense.dart';
import '../../../repositories/business/fixed_expense_repository.dart';
import '../../../repositories/business/variable_expense_repository.dart';
import '../../size_box_form.dart';
import '../../transaction_form.dart';

final _formKey = GlobalKey<FormState>();
final descriptionController = TextEditingController();
final valueController = TextEditingController();
String invoicingId = const Uuid().v1();
final descriptionFocusNode = FocusNode();
final valueFocusNode = FocusNode();

TransactionForm transactionForm = TransactionForm(
  title: "Adicione uma nova despesa",
  classification: "É uma despesa fixa ou variável",
  consumer1: Consumer<FixedExpenseRepository>(
    builder:
        (BuildContext context, FixedExpenseRepository fixed, Widget? widget) {
      return SizeBoxForm(
          onPressed: () async {
            FixedExpense fixedExpense = FixedExpense(
              description: descriptionController.text,
              value: double.parse(valueController.text),
              date: DateTime.now(),
              id: invoicingId,
            );
            await FixedExpenseRepository().addExpenseToFirestore(fixedExpense);
          },
          stringSnack: "Despesa fixa adicionada",
          stringButton: "Fixa");
    },
  ),
  consumer2: Consumer<VariableExpenseRepository>(
    builder: (BuildContext context, VariableExpenseRepository variable,
        Widget? widget) {
      return SizeBoxForm(
          onPressed: () async {
            VariableExpense variableExpense = VariableExpense(
              description: descriptionController.text,
              value: double.parse(valueController.text),
              date: DateTime.now(),
              id: invoicingId,
            );
            await VariableExpenseRepository()
                .addExpenseToFirestore(variableExpense);
          },
          stringSnack: "Despesa variável adicionada",
          stringButton: "Variável");
    },
  ),
);

