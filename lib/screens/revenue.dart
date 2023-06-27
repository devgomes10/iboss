import 'package:flutter/material.dart';

class Revenue extends StatelessWidget {
  const Revenue({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Receitas'), backgroundColor: Colors.green),
      body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 190),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Pagamento a Prazo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(alignment: Alignment.center,
                      minimumSize: MaterialStateProperty.all(
                        const Size(350, 80),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Pagamento à Vista',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(alignment: Alignment.center,
                    minimumSize: MaterialStateProperty.all(
                      const Size(350, 80),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
