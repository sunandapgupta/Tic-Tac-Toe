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

  // X = first
  // O = second
  String playAs = "X";

  bool valid(String name) {
    return RegExp(r'^[a-zA-Z0-9]{4,10}$').hasMatch(name);
  }

  void start() {
    if (!valid(p1.text)) return;

    if (widget.mode == "PVP" && !valid(p2.text)) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          mode: widget.mode,
          p1: p1.text,
          p2: widget.mode == "AI" ? "AI" : p2.text,
          difficulty: difficulty,

          // AI starts if player picks O
          aiFirst: playAs == "O",
        ),
      ),
    );
  }

  void showNameRules() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Name Rules"),
        content: const Text(
          "• 4–10 characters only\n"
          "• Letters and numbers only\n"
          "• No special symbols\n\n"
          "Example:\nAlex12",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showDifficultyInfo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Difficulty Info"),
        content: const Text(
          "Easy → Beginner AI\n\n"
          "Medium → Balanced AI\n\n"
          "Hard → Smart AI\n\n"
          "Expert → Perfect AI",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),

        iconTheme: const IconThemeData(color: Colors.white),

        title: Text(
          widget.mode == "AI" ? "Vs AI Setup" : "PvP Setup",
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PLAYER NAME TITLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Enter Player Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: showNameRules,
                  icon: const Icon(Icons.info_outline, color: Colors.white70),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: p1,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Player 1",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (widget.mode == "PVP")
              TextField(
                controller: p2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Player 2",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // DIFFICULTY TITLE
            if (widget.mode == "AI")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Difficulty",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: showDifficultyInfo,
                    icon: const Icon(Icons.info_outline, color: Colors.white70),
                  ),
                ],
              ),

            // DIFFICULTY DROPDOWN
            if (widget.mode == "AI")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: difficulty,
                  dropdownColor: const Color(0xFF1E1E1E),
                  isExpanded: true,
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: "Easy", child: Text("Easy")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "Hard", child: Text("Hard")),
                    DropdownMenuItem(value: "Expert", child: Text("Expert")),
                  ],
                  onChanged: (v) {
                    setState(() {
                      difficulty = v!;
                    });
                  },
                ),
              ),

            const SizedBox(height: 25),

            // TURN ORDER
            if (widget.mode == "AI")
              const Text(
                "Choose Turn Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 10),

            if (widget.mode == "AI")
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: "X",
                          groupValue: playAs,
                          activeColor: Colors.blue,
                          onChanged: (v) {
                            setState(() {
                              playAs = v!;
                            });
                          },
                        ),

                        const Text(
                          "Play First (X)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Radio<String>(
                          value: "O",
                          groupValue: playAs,
                          activeColor: Colors.red,
                          onChanged: (v) {
                            setState(() {
                              playAs = v!;
                            });
                          },
                        ),

                        const Text(
                          "Play Second (O)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "PLAY",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
