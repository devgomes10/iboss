import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/screens/business/categories_screen.dart';
import 'package:uuid/Uuid.dart'; // Import UUID corrigido
import '../../../controllers/business/fixed_expense_controller.dart';
import '../../../controllers/business/variable_expense_controller.dart';
import '../../../models/business/categories_model.dart';
import '../../../models/business/fixed_expense.dart';
import '../../../models/business/variable_expense.dart';

class ExpenseForm extends StatefulWidget {
  final FixedExpense? model1;
  final VariableExpense? model2;
  late CategoriesModel? selectedCategory;

  ExpenseForm({Key? key, this.model1, this.model2, this.selectedCategory}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
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
    final titleText = _isEditing1 || _isEditing2 ? "Editando despesa" : "Nova despesa";
    final buttonText1 = _isEditing1 ? "Confirmar" : "FIXA";
    final buttonText2 = _isEditing2 ? "Confirmar" : "VARIÁVEL";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20, right: 7, bottom: 10, left: 7),
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
                  hintText: "Descrição",
                  border: InputBorder.none,
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Insira um valor";
                  }
                  double? numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue <= 0) {
                    return "Deve ser maior que 0";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: valueController,
                focusNode: valueFocusNode,
                decoration: const InputDecoration(
                  hintText: "Valor",
                  border: InputBorder.none,
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.circleCheck),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Está pago?",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isExpensePaid,
                    onChanged: (newValue) async {
                      setState(() {
                        isExpensePaid = newValue;
                      });
                      final fixedExpenses = await FixedExpenseController().getFixedExpensesFromFirestore();
                      final variableExpenses = await VariableExpenseController().getVariableExpensesFromFirestore();
                      if (fixedExpenses.isNotEmpty) {
                        final firstExpense = fixedExpenses.first;
                        FixedExpenseController().updateFixedExpenseStatus(firstExpense.id, newValue);
                      }
                      if (variableExpenses.isNotEmpty) {
                        final firstExpense = variableExpenses.first;
                        VariableExpenseController().updateVariableExpenseStatus(firstExpense.id, newValue);
                      }
                    },
                  ),
                ],
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.calendar),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Data de pagamento",
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    FaIcon(FontAwesomeIcons.angleRight),
                  ],
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () async {
                  final selectedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesScreen(isSelecting: true),
                    ),
                  );
                  if (selectedCategory != null) {
                    setState(() {
                      this.widget.selectedCategory = selectedCategory;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.tags),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            widget.selectedCategory != null
                                ? widget.selectedCategory!.name
                                : "Categoria",
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.rotateRight),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Repetir",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isExpensePaid,
                    onChanged: (newValue) async {
                      setState(() {
                        isExpensePaid = newValue;
                      });
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
