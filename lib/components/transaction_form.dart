import 'package:flutter/material.dart';
import 'package:iboss/models/transaction_model.dart';
import 'package:uuid/Uuid.dart';

class TransactionForm extends StatefulWidget {
  final TransactionModel? model;

  const TransactionForm({super.key, this.model});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  bool isRevenue = false;
  bool isCompleted = false;
  bool isRepeat = false;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  final ptBr = const Locale('pt', 'BR');
  DateTime selectedPicker = DateTime.now();
  String invoicingId = const Uuid().v1();
  int numberOfRepeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      descriptionController.text = widget.model!.description;
      valueController.text = widget.model!.value.toString();
      isCompleted = widget.model!.isCompleted;
      selectedPicker = widget.model!.transactionDate;
      numberOfRepeats = widget.model!.numberOfRepeats;
      _isEditing = true;
      isRepeat = widget.model!.isRepeat;
      isRevenue = widget.model!.isRevenue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
