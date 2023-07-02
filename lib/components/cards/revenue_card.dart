import 'package:flutter/material.dart';

class RevenueCard extends StatelessWidget {
  final String description;
  final double value;
  final int date;
  const RevenueCard(this.description, this.value, this.date, {super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 350,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(width: 3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(description),
                Text('$value'),
              ],
            ),
            Text('$date'),
          ],
        ),
      ),
    );
  }
}