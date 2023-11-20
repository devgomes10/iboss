import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/catalog_form.dart';
import 'package:iboss/components/forms/business/revenue_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/business/product_controller.dart';
import 'package:iboss/models/business/product_model.dart';
import 'package:intl/intl.dart';

class CatalogView extends StatefulWidget {
  final bool? isSelecting;
  final double? catalogTotal;
  final RevenueForm? revenueForm;

  const CatalogView(
      {Key? key, this.isSelecting, this.catalogTotal, this.revenueForm})
      : super(key: key);

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final catalogController = ProductController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final TextEditingController _searchController = TextEditingController();

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
              icon: const FaIcon(FontAwesomeIcons.check),
              onPressed: () {
                // if (widget.revenueForm != null) {
                //   // Obtém o total dos preços dos produtos selecionados
                //   final totalSelectedPrice = catalogController
                //       .calculateTotalSelectedPrice();
                //   showConfirmation(context: context,
                //       title: totalSelectedPrice.toString(),
                //       onPressed: () {},
                //       messegerSnack: "messegerSnack",
                //       isError: false);
                //
                //   // Faça o que for necessário com o totalSelectedPrice, como atualizar o valor no widget.revenueForm
                //   // widget.revenueForm!.updateValueControllerWithTotalSelectedItems(totalSelectedPrice);
                // }
              },
            ),

        ],
        title: const Text("Catálogo"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: catalogController.getProductFromFirestore(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os produtos/serviços'),
            );
          }
          final products = snapshot.data;
          if (products == null || products.isEmpty) {
            return const Center(
              child: Text('Nenhum produto/serviço disponível.'),
            );
          }
          return Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (query) {

                },
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int i) {
                    final product = products[i];
                    return ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        real.format(product.price),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      leading: widget.isSelecting == true
                          ? StreamBuilder<Map<String, int>>(
                        stream: catalogController.selectedItemsStream,
                        initialData:
                        catalogController.selectedCatalogItems,
                        builder: (context, snapshot) {
                          final selectedItems = snapshot.data;
                          return Text(
                            'x ${selectedItems?[product.id] ?? 0}',
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
                                  .removeProductFromFirestore(product.id);
                            },
                            messegerSnack: "Produto/serviço deletado",
                            isError: false,
                          );
                        },
                      )
                          : null,
                      onTap: () {
                        if (widget.isSelecting == true) {
                          final id = product.id;
                          if (catalogController.selectedCatalogItems
                              .containsKey(id)) {
                            catalogController.selectedCatalogItems[id] =
                                (catalogController.selectedCatalogItems[id] ??
                                    0) +
                                    1;
                          } else {
                            catalogController.selectedCatalogItems[id] = 1;
                          }
                        } else {
                          NewCatalogBottomSheet.show(context, model: product);
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
