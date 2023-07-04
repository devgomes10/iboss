import 'package:iboss/models/card_revenue_now.dart';

class RevenueController {
  List<CardNow> revenueNow = [];

  RevenueController() {
    revenueNow = [
      CardNow(description: 'Corte de cabelo', value: 54.5),
      CardNow(description: 'Barba', value: 20.5),
    ];

    void newCardNow(String description, double value) {
      revenueNow.add(CardNow(description: description, value: value));
    }
  }
}
