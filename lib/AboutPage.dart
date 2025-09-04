import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("À propos"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '''Cette application calcule la facture d’électricité et de gaz. Pour l’option Sud, une contribution de 64,45 % est appliquée au coût total de l’électricité et du gaz (hors TVA), ainsi que les redevances fixes. Cette contribution réduit le montant total à payer. Pour l’option Nord, la contribution est de 0.
                project link: https://github.com/GasbaouiMohammedAlAmin/algeria-electricity-gas-bill-calculator
                email: aminegasa2015@hotmail.com''',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}