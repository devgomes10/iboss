import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/catalog_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/business/catalog_controller.dart';
import 'package:iboss/models/business/catalog_model.dart';
import 'package:intl/intl.dart';

class CatalogScreen extends StatefulWidget {
  final bool isSelecting;

  const CatalogScreen({super.key, required this.isSelecting});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final catalogController = CatalogController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      appBar: AppBar(
        actions: [
          if (widget.isSelecting == true)
            IconButton(
              onPressed: () {
                showConfirmation(
                    context: context,
                    title: "${catalogController.totalSelectedItems}",
                    onPressed: () {},
                    messegerSnack: "",
                    isError: false);
              },
              icon: FaIcon(FontAwesomeIcons.check),
            ),
        ],
        title: const Text("Catálogo"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CatalogModel>>(
        stream: catalogController.getCatalogFromFirestore(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CatalogModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os produtos/serviços'),
            );
          }
          final catalogs = snapshot.data;
          if (catalogs == null || catalogs.isEmpty) {
            return const Center(
              child: Text('Nenhum produto/serviço disponível.'),
            );
          }
          return Column(
            children: [
              TextField(
                controller: nameController,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: catalogs.length,
                  itemBuilder: (BuildContext context, int i) {
                    final catalog = catalogs[i];
                    return ListTile(
                      title: Text(
                        catalog.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        real.format(catalog.price),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: widget.isSelecting == true
                          ? StreamBuilder<Map<String, int>>(
                        stream: catalogController.selectedItemsStream,
                        initialData: catalogController.selectedCatalogItems,
                        builder: (context, snapshot) {
                          final selectedItems = snapshot.data;
                          return Text(
                            'x ${selectedItems?[catalog.id] ?? 0}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          );
                        },
                      )
                          : null,
                      trailing: widget.isSelecting == false
                          ? IconButton(
                        icon: const FaIcon(FontAwesomeIcons.trash),
                        onPressed: () {
                          showConfirmation(
                            context: context,
                            title:
                            "Deseja mesmo remover esse produto/serviço?",
                            onPressed: () {
                              catalogController
                                  .removeCatalogFromFirestore(catalog.id);
                            },
                            messegerSnack: "Produto/serviço deletado",
                            isError: false,
                          );
                        },
                      )
                          : null,
                      onTap: () {
                        if (widget.isSelecting == true) {
                          final id = catalog.id;
                          if (catalogController.selectedCatalogItems
                              .containsKey(id)) {
                            catalogController.selectedCatalogItems[id] =
                                (catalogController.selectedCatalogItems[id] ??
                                    0) +
                                    1;
                          } else {
                            catalogController.selectedCatalogItems[id] = 1;
                          }
                          catalogController
                              .updateTotalSelectedItems(catalogs);
                        } else {
                          NewCatalogBottomSheet.show(context, model: catalog);
                        }
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white),
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
          NewCatalogBottomSheet.show(context);
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  @override
  void dispose() {
    catalogController.dispose();
    super.dispose();
  }
}
