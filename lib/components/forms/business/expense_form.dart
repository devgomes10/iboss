import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/views/business/categories_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/Uuid.dart';
import '../../../controllers/business/expense_controller.dart';
import '../../../models/business/categories_model.dart';
import '../../../models/business/expense_model.dart';
import '../../show_snackbar.dart';

class ExpenseForm extends StatefulWidget {
  final ExpenseModel? model;
  late CategoriesModel? selectedCategory;

  ExpenseForm({Key? key, this.model, this.selectedCategory}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  bool isPaid = false;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final valueController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueFocusNode = FocusNode();
  DateTime selectedPicker = DateTime.now();
  final ptBr = const Locale('pt', 'BR');
  bool isRepeat = false;
  int numberOfRepeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      descriptionController.text = widget.model!.description;
      valueController.text = widget.model!.value.toString();
      isPaid = widget.model!.isPaid;
      selectedPicker = widget.model!.payday;
      numberOfRepeats = widget.model!.numberOfRepeats;
      _isEditing = true;
      isRepeat = widget.model!.isRepeat;
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
    final expenseModel = widget.model;
    final titleText = _isEditing ? "Editando despesa" : "Nova despesa";
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(titleText),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(7, 20, 7, 10),
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
                      const FaIcon(FontAwesomeIcons.circleCheck),
                      const SizedBox(
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
                    value: isPaid,
                    onChanged: (newValue) async {
                      setState(() {
                        isPaid = newValue;
                      });
                      final expenses =
                          await ExpenseController().getExpenseFromFirestore();
                      if (expenses.isNotEmpty) {
                        final firstExpense = expenses.first;
                        ExpenseController()
                            .updateExpenseStatus(firstExpense.id, newValue);
                      }
                    },
                  ),
                ],
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    locale: ptBr,
                    initialDate: selectedPicker,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (picked != null) {
                    setState(
                      () {
                        selectedPicker = picked;
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.calendar),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(
                            DateFormat.yMMMMd('pt_BR').format(selectedPicker),
                            style: GoogleFonts.raleway(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
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
                      builder: (context) => CategoriesView(isSelecting: true),
                    ),
                  );
                  if (selectedCategory != null) {
                    setState(() {
                      widget.selectedCategory = selectedCategory;
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
                          const FaIcon(FontAwesomeIcons.tags),
                          const SizedBox(
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
                      const FaIcon(FontAwesomeIcons.angleRight),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 22,
                color: Colors.grey,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.rotateRight),
                          const SizedBox(
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
                        value: isRepeat,
                        onChanged: (newValue) async {
                          setState(() {
                            isRepeat = newValue;
                          });
                          final expense = await ExpenseController()
                              .getExpenseFromFirestore();

                          if (expense.isNotEmpty) {
                            final firstExpense = expense.first;
                            ExpenseController()
                                .updateExpenseStatus(firstExpense.id, newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  if (isRepeat)
                    Column(
                      children: [
                        const Text("Quantidade de Repetições:"),
                        CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int value) {
                            setState(() {
                              numberOfRepeats = value + 1;
                            });
                          },
                          children: List.generate(10, (index) {
                            return Text((index + 1).toString());
                          }),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                          height: 8,
                        ),
                        Text("$numberOfRepeats vezes de R\$ 55.000,00"),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Consumer<ExpenseController>(
                builder: (BuildContext context, ExpenseController expense,
                    Widget? widget) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (!_isEditing) {
                        if (_formKey.currentState!.validate()) {
                          ExpenseModel expense = ExpenseModel(
                            id: invoicingId,
                            description: descriptionController.text,
                            value: double.parse(valueController.text),
                            isPaid: isPaid,
                            payday: selectedPicker,
                            category: "",
                            isRepeat: isRepeat,
                            numberOfRepeats: numberOfRepeats,
                          );

                          if (expenseModel != null) {
                            expense.id = expenseModel.id;
                          }

                          await ExpenseController()
                              .addExpenseToFirestore(expense);

                          if (!_isEditing) {
                            showSnackbar(
                              context: context,
                              menssager: "Despesa adicionada",
                              isError: false,
                            );
                          } else {
                            showSnackbar(
                              context: context,
                              menssager: "Despesa editada",
                              isError: false,
                            );
                          }

                          Navigator.pop(context);
                        }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      minimumSize: const Size(300, 40),
                    ),
                    child: const Text("CONFIRMAR"),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
