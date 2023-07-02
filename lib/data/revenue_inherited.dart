import 'package:flutter/material.dart';
import 'package:iboss/components/cards/revenue_card.dart';

class RevenueInhereted extends InheritedWidget {
  RevenueInhereted({
    super.key,
    required Widget child,
  }) : super(child: child);

  final List<RevenueCard> nowList = [
    RevenueCard(
      'corte de cabelo',
      15.00,
    ),
    RevenueCard(
      'corte de cabelo e barba',
      20.00,
    ),
  ];

  void newRevenueCard(String description, double value) {
    nowList.add(
      RevenueCard(
        description,
        value,
      ),
    );
  }

  static RevenueInhereted of(BuildContext context) {
    final RevenueInhereted? result =
        context.dependOnInheritedWidgetOfExactType<RevenueInhereted>();
    assert(result != null, 'No RevenueInhereted found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RevenueInhereted old) {
    return old.nowList.length != nowList.length;
  }
}
