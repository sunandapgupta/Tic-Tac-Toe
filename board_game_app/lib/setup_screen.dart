import 'package:flutter/material.dart';
import 'game_screen.dart';

class SetupScreen extends StatefulWidget {
  final String mode;

  const SetupScreen({super.key, required this.mode});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController p1 = TextEditingController();
  final TextEditingController p2 = TextEditingController();

  String difficulty = "Medium";

  bool valid(String name) {
    return RegExp(r'^[a-zA-Z0-9]{4,10}$').hasMatch(name);
  }

  void start() {
    if (!valid(p1.text)) return;

    if (widget.mode == "PVP" && !valid(p2.text)) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          mode: widget.mode,
          p1: p1.text,
          p2: widget.mode == "AI" ? "AI" : p2.text,
          difficulty: difficulty,
        ),
      ),
    );
  }

  void info() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rules"),
        content: const Text(
          "4-10 characters only\nNo special symbols\nExample: Alex12\n",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == "AI" ? "Vs AI Setup" : "PvP Setup"),
        actions: [
          IconButton(onPressed: info, icon: const Icon(Icons.info))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: p1,
              decoration: const InputDecoration(labelText: "Player 1"),
            ),

            const SizedBox(height: 10),

            if (widget.mode == "PVP")
              TextField(
                controller: p2,
                decoration: const InputDecoration(labelText: "Player 2"),
              ),

            const SizedBox(height: 20),

            if (widget.mode == "AI")
              DropdownButton<String>(
                value: difficulty,
                items: const [
                  DropdownMenuItem(value: "Easy", child: Text("Easy")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Hard", child: Text("Hard")),
                ],
                onChanged: (v) => setState(() => difficulty = v!),
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: start,
              child: const Text("PLAY"),
            ),
          ],
        ),
      ),
    );
  }
}