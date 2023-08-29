import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff003060),
      appBar: AppBar(
        backgroundColor: Color(0xff003060),
        title: const Text('Cadastro'),
      ),
      body: Center(
        child: Padding(
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
                    decoration: const InputDecoration(
                        labelText: 'Nome',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
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
                    decoration: const InputDecoration(
                        labelText: 'E-mail',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
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
                    decoration: const InputDecoration(
                        labelText: 'Telefone',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
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
                    decoration: const InputDecoration(
                        labelText: 'Data de Nascimento',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
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
                    decoration: const InputDecoration(
                        labelText: 'CPF',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
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
                    decoration: const InputDecoration(
                        labelText: 'Senha',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Confirme a senha";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Confirme a senha',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelStyle: TextStyle(color: Colors.grey)),
                    obscureText: true,
                  ),
                  const SizedBox(height: 50.0),
                  ElevatedButton(
                    onPressed: () {
                      // Adicione aqui a lógica para salvar os dados de cadastro
                    },
                    style: TextButton.styleFrom(
                      elevation: 4,
                      backgroundColor: Colors.grey[200],
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003060),
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
