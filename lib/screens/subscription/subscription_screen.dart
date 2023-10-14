import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../components/menu_navigation.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

InAppPurchase _inAppPurchase = InAppPurchase.instance;
late StreamSubscription<dynamic> _streamSubscription;
List<ProductDetails> _products = [];
const _variant = {"boss171819"};

class SubscriptionScreenState extends State<SubscriptionScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _streamSubscription = purchaseUpdated.listen(
          (purchaseList) {
        _ouvirCompra(purchaseList, context);
      },
      onDone: () {
        _streamSubscription.cancel();
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ocorreu um erro ao processar a compra.")));
      },
    );
    _iniciarLoja();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff003060),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Seu período de teste gratuito acabou.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                _comprarAssinatura();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                textStyle: const TextStyle(color: Color(0xff003060)),
              ),
              child: const Text("Assinar Plano"),
            ),
          ],
        ),
      ),
    );
  }

  _iniciarLoja() async {
    ProductDetailsResponse productDetailsResponse =
    await _inAppPurchase.queryProductDetails(_variant);
    if (productDetailsResponse.error == null) {
      setState(() {
        _products = productDetailsResponse.productDetails;
      });
    }
  }

  _redirecionarParaMenu() {
    // Navegar para a tela do MenuNavigator após uma compra bem-sucedida.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MenuNavigation(transaction: user!),
      ),
    );
  }

  _ouvirCompra(List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
    purchaseDetailsList.forEach(
          (PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sua compra está pendente de processamento."),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Houve um erro ao processar sua compra."),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Sua compra foi realizada com sucesso."),
            ),
          );

          // Redirecionar o usuário para a tela MenuNavigation após a compra bem-sucedida.
          _redirecionarParaMenu();
        }
      },
    );
  }

  _comprarAssinatura() {
    if (_products.isNotEmpty) {
      final PurchaseParam param = PurchaseParam(productDetails: _products[0]);
      _inAppPurchase.buyConsumable(purchaseParam: param);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Não há produtos disponíveis para compra."),
        ),
      );
    }
  }
}
