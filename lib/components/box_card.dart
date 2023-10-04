import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class BoxCard extends StatelessWidget {
  final String title;
  final String subTitle1;
  final String subTitle2;
  final Stream<double> stream1;
  final Stream<double> stream2;
  final Stream<double> streamTotal;
  final Widget screen;
  final Color color;

  BoxCard({
    super.key,
    required this.title,
    this.subTitle1 = "Fixas",
    this.subTitle2 = "Variáveis",
    required this.streamTotal,
    required this.stream1,
    required this.stream2,
    required this.screen,
    required this.color,
  });

  final NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    FaIcon(
                      FontAwesomeIcons.arrowTrendUp,
                      color: color,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Total",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                StreamBuilder<double>(
                  stream: streamTotal,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final totalValue = snapshot.data;
                      return Text(
                        real.format(totalValue!),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('erro...');
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          subTitle1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        StreamBuilder<double>(
                          stream: stream1,
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final totalStream1 = snapshot.data;
                              return Text(
                                real.format(totalStream1),
                                style: TextStyle(
                                  color: color,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text("erro...");
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          subTitle2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        StreamBuilder<double>(
                          stream: stream2,
                          builder: (BuildContext context,
                              AsyncSnapshot<double> snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final totalStream2 = snapshot.data;
                              return Text(
                                real.format(totalStream2),
                                style: TextStyle(
                                  color: color,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Text("erro...");
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
