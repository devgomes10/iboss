import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class Dash extends StatefulWidget {
  final Stream<List<double>> streamDeDados;
  final String titulo;
  final String rotulo1;
  final String rotulo2;

  const Dash({
    required this.streamDeDados,
    required this.titulo,
    required this.rotulo1,
    required this.rotulo2,
  });

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: widget.streamDeDados,
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final List<double> dados = snapshot.data!;
        final double valor1 = dados[0];
        final double valor2 = dados[1];

        final double total = valor1 + valor2;

        return Column(
          children: [
            // Seu título e botões de navegação aqui

            SizedBox(
              width: 250,
              height: 250,
              child: total > 0
                  ? Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          showTitle: false,
                          color: Colors.green,
                          value: valor1,
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          color: Colors.blue,
                          value: valor2,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${valor1 + valor2}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
                  : Center(
                child: Text('Sem registros'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 4),
                Column(
                  children: [
                    Text(
                      widget.rotulo2,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${valor2}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 70),
                SizedBox(
                  width: 4,
                ),
                Column(
                  children: [
                    Text(
                      widget.rotulo1,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${valor1}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
