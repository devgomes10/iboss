import 'package:flutter/material.dart';
import 'package:iboss/components/show_snackbar.dart';
import 'package:iboss/controllers/business/category_controller.dart';
import 'package:iboss/models/business/category_model.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewCategoryBottomSheet {
  static void show(BuildContext context, {CategoryModel? model}) {
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
        return _BottomSheetNewCategory(
          model: model,
        );
      },
    );
  }
}

class _BottomSheetNewCategory extends StatefulWidget {
  final CategoryModel? model;

  const _BottomSheetNewCategory({this.model});

  @override
  __BottomSheetNewCategoryState createState() =>
      __BottomSheetNewCategoryState();
}

class __BottomSheetNewCategoryState extends State<_BottomSheetNewCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String invoicingId = const Uuid().v1();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      nameController.text = widget.model!.name;
      _isEditing = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryModel = widget.model;
    final titleText = _isEditing ? "Editando categoria" : "Nova categoria";
    return SingleChildScrollView(
      reverse: true,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
                  if (value.length > 40) {
                    return "Nome muito grande";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                controller: nameController,
                // focusNode: descriptionFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Nome da categoria',
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
                child: Consumer<CategoryController>(
                  builder: (BuildContext context, CategoryController category,
                      Widget? widget) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 130,
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                CategoryModel category = CategoryModel(
                                  id: invoicingId,
                                  name: nameController.text,
                                  budget: 2,
                                );

                                if (categoryModel != null) {
                                  category.id = categoryModel.id;
                                }
                                await CategoryController()
                                    .addCategoryToFirestore(category);

                                Navigator.pop(context);

                                if (!_isEditing) {
                                  showSnackbar(
                                      context: context,
                                      menssager: "Categoria editada",
                                      isError: false);
                                } else {
                                  showSnackbar(
                                      context: context,
                                      menssager: "Categoria adicionada",
                                      isError: false);
                                }
                              }
                            },
                            child: const Text(
                              "CONFIRMAR",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF5CE1E6),
                              ),
                            ),
                          ),
                        ),
                      ],
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
