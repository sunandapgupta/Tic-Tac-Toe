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

  // Player choice: X = first, O = second
  String playAs = "X";

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

          // AI starts if player chooses O
          aiFirst: playAs == "O",
        ),
      ),
    );
  }

  void showRules() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rules"),
        content: const Text(
          "• 4–10 characters only\n"
          "• No special symbols\n"
          "• Example: Alex12\n\n"
          "• Best of 5 match system",
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
          IconButton(
            onPressed: showRules,
            icon: const Icon(Icons.info),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: p1,
              decoration: const InputDecoration(
                labelText: "Player 1",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            if (widget.mode == "PVP")
              TextField(
                controller: p2,
                decoration: const InputDecoration(
                  labelText: "Player 2",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20),

            // Difficulty
            if (widget.mode == "AI")
              DropdownButton<String>(
                value: difficulty,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: "Easy", child: Text("Easy")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Hard", child: Text("Hard")),
                ],
                onChanged: (v) => setState(() => difficulty = v!),
              ),

            const SizedBox(height: 20),

            // Play order selection
            if (widget.mode == "AI")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Choose Turn Order",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: "X",
                            groupValue: playAs,
                            onChanged: (v) => setState(() => playAs = v!),
                          ),
                          const Text("Play First (X)"),
                        ],
                      ),

                      const SizedBox(width: 20),

                      Row(
                        children: [
                          Radio<String>(
                            value: "O",
                            groupValue: playAs,
                            onChanged: (v) => setState(() => playAs = v!),
                          ),
                          const Text("Play Second (O)"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: start,
                child: const Text("PLAY"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}