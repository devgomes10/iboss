import 'package:iboss/models/card_revenue_now.dart';

class CardNowRepository {
  static List<CardNow> table = [
    CardNow(
        description: 'Corte de Cabelo',
        value: 25.00,
    ),
    CardNow(
      description: 'Corte de Cabelo e barba',
      value: 35.00,
    ),
    CardNow(
      description: 'Corte de Cabelo e sobrancelha',
      value: 35.00,
    ),
  ];

}