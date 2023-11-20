import 'package:flutter/material.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/controllers/business/product_controller.dart';
import 'package:iboss/models/business/product_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewCatalogBottomSheet {
  static void show(BuildContext context, {ProductModel? model}) {
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
        return _BottomSheetNewCatalog(
          model: model,
        );
      },
    );
  }
}

class _BottomSheetNewCatalog extends StatefulWidget {
  final ProductModel? model;

  const _BottomSheetNewCatalog({this.model});

  @override
  __BottomSheetNewCatalogState createState() => __BottomSheetNewCatalogState();
}

class __BottomSheetNewCatalogState extends State<_BottomSheetNewCatalog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  String invoicingId = const Uuid().v1();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      priceController.text = widget.model!.price.toString();
      _isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogModel = widget.model;
    final titleText =
        _isEditing ? "Editando produto/serviço" : "Novo produto/serviço";

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
                    return "Insira o nome";
                  }
                  if (value.length > 80) {
                    return "Nome muito grande";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: nameController,
                // focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nome',
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
                    return "Insira o preço";
                  }
                  double? numericValue = double.tryParse(value);
                  if (numericValue == null || numericValue <= 0) {
                    return "Deve ser maior que zero";
                  }
                  return null;
                },

                keyboardType: TextInputType.number,
                controller: priceController,
                // focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Preço',
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
                child: Consumer<ProductController>(
                  builder: (BuildContext context, ProductController catalog,
                      Widget? widget) {
                    return SizedBox(
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ProductModel catalog = ProductModel(
                              id: invoicingId,
                              name: nameController.text,
                              price: double.parse(priceController.text),
                              soldAmount: 2,
                            );

                            if (catalogModel != null) {
                              catalog.id = catalogModel.id;
                            }
                            await ProductController()
                                .addProductToFirestore(catalog);

                            Navigator.pop(context);

                            if (!_isEditing) {
                              showSnackbar(
                                  context: context,
                                  menssager: "Produto/serviço editado",
                                  isError: false);
                            } else {
                              showSnackbar(
                                  context: context,
                                  menssager: "Produto/serviço adicionado",
                                  isError: false);
                            }
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF5CE1E6),
                        ),
                        child: const Text(
                          "CONFIRMAR",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF5CE1E6),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
