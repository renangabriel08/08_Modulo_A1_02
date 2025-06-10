import 'package:flutter/material.dart';

class App {
  static bool bateria = false;

  static modalNet(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(
            'Sem conexão com internet, seus dados podem não estar completamente salvos.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static modalEconomia(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Text(
            'Seu dispositivo está no modo economia de energia, alguns recursos podem ser limitados.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  static modalBateria(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Atenção. Bateria Baixa.'),
        content: SingleChildScrollView(
          child: Image.asset('assets/bateria.png'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
