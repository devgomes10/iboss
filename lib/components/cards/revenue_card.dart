import 'package:flutter/material.dart';

class RevenueCard extends StatefulWidget {
  final String description;
  final double value;
  const RevenueCard(this.description, this.value,{super.key});

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard> {
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
                Text(widget.description),
                Text('${widget.value}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}