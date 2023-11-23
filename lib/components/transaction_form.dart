import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/controllers/business/category_controller.dart';
import 'package:iboss/controllers/transaction_controller.dart';
import 'package:iboss/models/transaction_model.dart';
import 'package:iboss/views/business/catalog_view.dart';
import 'package:iboss/views/business/categories_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/Uuid.dart';

import '../models/business/category_model.dart';

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
  DateTime transactionDate = DateTime.now();
  String invoicingId = const Uuid().v1();
  int numberOfRepeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      descriptionController.text = widget.model!.description;
      valueController.text = widget.model!.value.toString();
      isCompleted = widget.model!.isCompleted;
      transactionDate = widget.model!.transactionDate;
      numberOfRepeats = widget.model!.numberOfRepeats;
      _isEditing = true;
      isRepeat = widget.model!.isRepeat;
      isRevenue = widget.model!.isRevenue;
    }
  }

  @override
  Widget build(BuildContext context) {
    CategoryModel? selectedCategory =
        Provider.of<CategoryController>(context).selectedCategory;
    final transactionModel = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isRevenue
              ? _isEditing
                  ? "Editando receita"
                  : "Adicionando receita"
              : _isEditing
                  ? "Editando despesa"
                  : "Adicionando despesa",
        ),
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
                        isRevenue ? "Recebeu?" : "Está paga?",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isCompleted,
                    onChanged: (newValue) async {
                      setState(() {
                        isCompleted = newValue;
                      });
                      final transaction = await TransactionController()
                          .getTransactionFromFirestore();
                      if (transaction.isNotEmpty) {
                        final firstTransaction = transaction.first;
                        TransactionController().updateStatus(
                            firstTransaction.id, "isCompleted", newValue);
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
                    initialDate: transactionDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                  );
                  if (picked != null) {
                    setState(
                      () {
                        transactionDate = picked;
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
                            DateFormat.yMMMMd('pt_BR').format(transactionDate),
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
                onTap: () {
                  isRevenue
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CatalogView(
                              isSelecting: true,
                            ),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriesView(
                              isSelecting: true,
                            ),
                          ),
                        );
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
                            isRevenue
                                ? "Catálogo"
                                : selectedCategory != null
                                    ? selectedCategory!.name
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
                            if (isRepeat) {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SafeArea(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          // const Text("Quantidade de Repetições:"),
                                          CupertinoPicker(
                                            itemExtent: 32,
                                            scrollController:
                                                FixedExtentScrollController(
                                              initialItem: 1,
                                            ),
                                            onSelectedItemChanged: (int value) {
                                              setState(() {
                                                if (isRepeat) {
                                                  numberOfRepeats = value + 1;
                                                }
                                              });
                                            },
                                            children:
                                                List.generate(10, (index) {
                                              return Text(
                                                  (index + 1).toString());
                                            }),
                                          ),
                                          // Text("$numberOfRepeats vezes de R\$ 55.000,00"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          });
                          final transaction = await TransactionController()
                              .getTransactionFromFirestore();
                          if (transaction.isNotEmpty) {
                            final firstTransaction = transaction.first;
                            TransactionController().updateStatus(
                                firstTransaction.id, "isRepeat", newValue);
                          }
                        },
                      ),
                    ],
                  ),
                  if (isRepeat)
                    Container(
                      child: Column(
                        children: [
                          const Text("Quantidade de Repetições:"),
                          CupertinoPicker(
                            itemExtent: 32,
                            onSelectedItemChanged: (int value) {
                              setState(() {
                                if (isRepeat) {
                                  numberOfRepeats = value + 1;
                                }
                              });
                            },
                            children: List.generate(10, (index) {
                              return Text((index + 1).toString());
                            }),
                          ),
                          Text("$numberOfRepeats vezes de R\$ 55.000,00"),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Consumer<TransactionController>(
                builder: (BuildContext context,
                    TransactionController transaction, Widget? widget) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!isRepeat) {
                          numberOfRepeats = 1;
                        }

                        TransactionModel newTransaction;

                        if (isRevenue == true) {
                          newTransaction = TransactionModel(
                            id: _isEditing ? transactionModel!.id : invoicingId,
                            isRevenue: isRevenue,
                            description: descriptionController.text,
                            value: double.parse(valueController.text),
                            isCompleted: isCompleted,
                            transactionDate: transactionDate,
                            isRepeat: isRepeat,
                            numberOfRepeats: isRepeat ? numberOfRepeats : 1,
                          );
                        } else {
                          newTransaction = TransactionModel(
                            id: _isEditing ? transactionModel!.id : invoicingId,
                            isRevenue: isRevenue,
                            description: descriptionController.text,
                            value: double.parse(valueController.text),
                            isCompleted: isCompleted,
                            transactionDate: transactionDate,
                            category: selectedCategory,
                            isRepeat: isRepeat,
                            numberOfRepeats: isRepeat ? numberOfRepeats : 1,
                          );
                        }

                        if (_isEditing) {
                          await transaction
                              .updateTransactionInFirestore(newTransaction);
                          showSnackbar(
                            context: context,
                            menssager: "Editada",
                            isError: false,
                          );
                        } else {
                          await transaction
                              .addTransactionToFirestore(newTransaction);
                          showSnackbar(
                            context: context,
                            menssager: "Adicionada",
                            isError: false,
                          );
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      minimumSize: const Size(300, 40),
                    ),
                    child: const Text("CONFIRMAR"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
