import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildButton('Meu cadastro', Icons.person, () {
              // Lógica para abrir a tela de cadastro
              print('Abrir tela de cadastro');
            }),
            _buildButton('Evolve Premium', Icons.star, () {
              // Lógica para adquirir o plano premium
              print('Adquirir o plano premium');
            }),
            _buildButton('Sair do aplicativo', Icons.exit_to_app, () {
              // Lógica para sair do aplicativo
              print('Sair do aplicativo');
            }),
            _buildButton('Cancelar plano', Icons.cancel, () {
              // Lógica para cancelar o plano premium
              print('Cancelar plano premium');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.teal, // Cor de fundo do botão
          onPrimary: Colors.white, // Cor do texto do botão
          padding: EdgeInsets.all(16), // Espaçamento interno do botão
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Borda arredondada do botão
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Settings(),
  ));
}
