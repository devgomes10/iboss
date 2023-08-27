import 'package:flutter/material.dart';
import 'package:iboss/screens/login/login.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.teal,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 40, top: 25),
          child: const Text('Configurações'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 350,
              child: _buildButton('Meu cadastro', Icons.person, () {
                // Lógica para abrir a tela de cadastro
                print('Abrir tela de cadastro');
              }),
            ),
            Container(
              width: 350,
              child: _buildButton('Evolve Premium', Icons.star, () {
                // Lógica para adquirir o plano premium
                print('Adquirir o plano premium');
              }),
            ),
            Container(
              width: 350,
              child: _buildButton(
                'Sair do aplicativo',
                Icons.exit_to_app,
                () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      scrollable: true,
                      title: const Text(
                          'Você realmente deseja sair da sua conta?'),
                      content: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('NÃO'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                  );
                                },
                                child: Text('SIM'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: 350,
              child: _buildButton(
                'Cancelar plano',
                Icons.cancel,
                () {
                  // Lógica para cancelar o plano premium
                  print('Cancelar plano premium');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          // Cor do texto do botão
          padding: const EdgeInsets.all(16),
          // Espaçamento interno do botão
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Borda arredondada do botão
          ),
        ),
      ),
    );
  }
}
