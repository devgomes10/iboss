import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 5,
          foregroundColor: Colors.white, backgroundColor: Colors.teal, // Cor do texto do botão
          padding: const EdgeInsets.all(16), // Espaçamento interno do botão
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Borda arredondada do botão
          ),
        ),
      ),
    );
  }
}