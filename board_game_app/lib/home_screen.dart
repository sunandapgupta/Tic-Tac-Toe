import 'package:flutter/material.dart';
import 'setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tic Tac Toe Pro")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SetupScreen(mode: "AI"),
                  ),
                );
              },
              child: const Text("Human vs AI"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SetupScreen(mode: "PVP"),
                  ),
                );
              },
              child: const Text("Human vs Human"),
            ),
          ],
        ),
      ),
    );
  }
}