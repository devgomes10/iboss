import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione seu nome";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione um e-mail";
                    }
                    if (!value.contains("@")) {
                      return "Adicione um e-mail válido";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione seu telefone";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione sua data de nascimento";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione seu CPF";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione uma senha";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    // Adicione aqui a lógica para salvar os dados de cadastro
                  },
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}