import 'package:flutter/material.dart';

class RevenueInhereted extends InheritedWidget {
  RevenueInhereted({
    super.key,
    required Widget child,
  }) : super(child: child);

  final List nowList = [];

  static RevenueInhereted of(BuildContext context) {
    final RevenueInhereted? result = context.dependOnInheritedWidgetOfExactType<RevenueInhereted>();
    assert(result != null, 'No RevenueInhereted found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RevenueInhereted old) {
    return ;
  }
}
