import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iboss/components/forms/business/catalog_form.dart';
import 'package:iboss/components/show_confirmation.dart';
import 'package:iboss/controllers/business/catalog_controller.dart';
import 'package:iboss/models/business/catalog_model.dart';
import 'package:intl/intl.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final catalogController = CatalogController();
  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Catálogo"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<CatalogModel>>(
        stream: catalogController.getCatalogFromFirestore(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CatalogModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
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
          return ListView.separated(
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
                trailing: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash),
                  onPressed: () {
                    showConfirmation(
                      context: context,
                      title: "Deseja mesmo remover esse produto/serviço?",
                      onPressed: () {
                        catalogController
                            .removeCatalogFromFirestore(catalog.id);
                      },
                      messegerSnack: "Produto/serviço deletado",
                      isError: false,
                    );
                  },
                ),
                onTap: () {
                  NewCatalogBottomSheet.show(context, model: catalog);
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(color: Colors.white),
            padding: const EdgeInsets.only(
              top: 14,
              left: 16,
              bottom: 80,
              right: 16,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NewCatalogBottomSheet.show(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
