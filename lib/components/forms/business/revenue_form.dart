import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/controllers/business/revenue_controller.dart';
import 'package:iboss/models/business/revenue_model.dart';
import 'package:iboss/views/business/catalog_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RevenueForm extends StatefulWidget {
  final RevenueModel? model;

  const RevenueForm({Key? key, this.model}) : super(key: key);

  @override
  State<RevenueForm> createState() => _RevenueFormState();
}

class _RevenueFormState extends State<RevenueForm> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController datePickerController = TextEditingController();
  final descriptionController = TextEditingController();
  String invoicingId = const Uuid().v1();
  final descriptionFocusNode = FocusNode();
  final valueController = TextEditingController();
  final valueFocusNode = FocusNode();
  bool isRepeat = false;
  bool isReceived = false;
  DateTime selectedPicker = DateTime.now();
  final ptBr = const Locale('pt', 'BR');
  int numberOfRepeats = 1;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      descriptionController.text = widget.model!.description;
      valueController.text = widget.model!.value.toString();
      isReceived = widget.model!.isReceived;
      selectedPicker = widget.model!.receiptDate;
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
    final titleText = _isEditing ? "Editando receita" : "Nova receita";
    final revenueModel = widget.model;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(titleText),
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
                        "Recebeu?",
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isReceived,
                    onChanged: (newValue) async {
                      setState(() {
                        isReceived = newValue;
                      });
                      final revenue =
                          await RevenueController().getRevenueFromFirestore();
                      if (revenue.isNotEmpty) {
                        final firstRevenue = revenue.first;
                        RevenueController()
                            .updateReceivedStatus(firstRevenue.id, newValue);
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CatalogView(isSelecting: true),
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
                            "Catálogo",
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
                          final revenue = await RevenueController()
                              .getRevenueFromFirestore();

                          if (revenue.isNotEmpty) {
                            final firstRevenue = revenue.first;
                            RevenueController()
                                .updateRepeatStatus(firstRevenue.id, newValue);
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
                              if (isRepeat) {
                                numberOfRepeats = value + 1;
                              }
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
              Consumer<RevenueController>(
                builder: (BuildContext context, RevenueController revenue,
                    Widget? widget) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!isRepeat) {
                          numberOfRepeats = 1;
                        }

                        RevenueModel updatedRevenue = RevenueModel(
                          id: _isEditing ? revenueModel!.id : invoicingId,
                          description: descriptionController.text,
                          value: double.parse(valueController.text),
                          isReceived: isReceived,
                          receiptDate: selectedPicker,
                          isRepeat: isRepeat,
                          numberOfRepeats: isRepeat ? numberOfRepeats : 1,
                        );

                        if (_isEditing) {
                          await RevenueController()
                              .updateRevenueInFirestore(updatedRevenue);
                          showSnackbar(
                            context: context,
                            menssager: "Receita editada",
                            isError: false,
                          );
                        } else {
                          await RevenueController()
                              .addRevenueToFirestore(updatedRevenue);
                          showSnackbar(
                            context: context,
                            menssager: "Receita adicionada",
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
