import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/business/category_controller.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/models/business/category_model.dart';

import '../../components/forms/business/categories_form.dart';

class CategoriesView extends StatefulWidget {
  final bool isSelecting;

  const CategoriesView({Key? key, required this.isSelecting}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Categorias"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CategoryModel>>(
        stream: CategoryController().getCategoryFromFirestore(),
        builder: (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar as categorias'),
            );
          }
          final categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return const Center(
              child: Text('Nenhuma categoria disponível'),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int i) {
                    final category = categories[i];
                    return ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.tag,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      trailing: widget.isSelecting == false
                          ? IconButton(
                        onPressed: () {
                          showConfirmation(
                            context: context,
                            title: "Deseja deletar essa categoria?",
                            onPressed: () {
                              CategoryController().removeCategoryFromFirestore(category.id);
                            },
                            messegerSnack: "Categoria deletada",
                            isError: false,
                          );
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                        ),
                      )
                          : null,
                      onTap: () {
                        if (widget.isSelecting == true) {
                          Navigator.pop(context, category);
                        } else {
                          // Aqui você pode fazer algo se estiver editando
                          NewCategoryBottomSheet.show(context, model: category);
                        }
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(color: Colors.white),
                  padding: const EdgeInsets.only(
                    top: 14,
                    left: 16,
                    bottom: 80,
                    right: 16,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: widget.isSelecting == false
          ? FloatingActionButton(
        onPressed: () {
          NewCategoryBottomSheet.show(context);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      )
          : null,
    );
  }
}
