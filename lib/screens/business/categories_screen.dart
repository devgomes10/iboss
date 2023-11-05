import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/controllers/business/categories_controller.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/models/business/categories_model.dart';

import '../../components/forms/business/categories_form.dart';

class CategoriesScreen extends StatefulWidget {
  final bool isSelecting;

  CategoriesScreen({Key? key, required this.isSelecting}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Categorias"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CategoriesModel>>(
        stream: CategoriesController().getCategoriesFromFirestore(),
        builder: (BuildContext context, AsyncSnapshot<List<CategoriesModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar as categorias'),
            );
          }
          final categories = snapshot.data;
          if (categories == null || categories.isEmpty) {
            return Center(
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
                      leading: FaIcon(
                        FontAwesomeIcons.tag,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: TextStyle(
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
                              CategoriesController().removeCategoriesFromFirestore(category.id);
                            },
                            messegerSnack: "Categoria deletada",
                            isError: false,
                          );
                        },
                        icon: FaIcon(
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
                  separatorBuilder: (_, __) => Divider(color: Colors.white),
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
        child: FaIcon(FontAwesomeIcons.plus),
      )
          : null,
    );
  }
}
