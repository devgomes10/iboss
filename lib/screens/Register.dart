import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                SizedBox(height: 16.0),
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
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione seu telefone";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione sua data de nascimento";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione seu CPF";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Adicione uma senha";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    // Adicione aqui a lógica para salvar os dados de cadastro
                  },
                  child: Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}