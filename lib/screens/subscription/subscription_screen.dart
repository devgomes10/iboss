import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final String subscriptionId = 'boss-plan'; // ID do plano de assinatura

  // Função para buscar detalhes do produto
  Future<void> loadProducts() async {
    final Set<String> productIds = {subscriptionId};

    ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Lidar com produtos não encontrados, se necessário
      return;
    }

    // Iniciar o processo de compra após buscar os detalhes do produto
    buySubscription();
  }

  // Função para iniciar o processo de compra
  Future<void> buySubscription() async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: ProductDetails(
          id: subscriptionId,
          title: 'Nome do seu plano',
          description: 'Descrição do seu plano',
          price: 'Preço do plano',
          currencyCode: 'BRL',
          // Substitua pelo código de moeda correto
          rawPrice: 1000, // Substitua pelo preço correto em centavos
        ),
      );

      final success = await InAppPurchase.instance.buyConsumable(
        purchaseParam: purchaseParam,
      );

      if (success) {
        // A compra foi concluída com sucesso
        // Atualize o estado da assinatura do usuário e redirecione-o para a tela desejada
      } else {
        print("erro...");
        // Erro na compra
      }
    } catch (e) {
      // Erro inesperado durante a compra
      print('Erro inesperado durante a compra: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff003060),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("O período de teste gratuito acabou"),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: loadProducts, // Agora chama loadProducts()
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              textStyle: const TextStyle(color: Color(0xff003060)),
            ),
            child: const Text("Assinar plano"),
          ),
        ],
      ),
    );
  }
}
