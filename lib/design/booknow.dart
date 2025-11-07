import 'package:flutter/material.dart';

void main() => runApp(const booknow());

class booknow extends StatelessWidget {
  const booknow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Book Now"), backgroundColor: Colors.orange),
        body: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Trip to Paris", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Price: \$899", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Trip Booked Successfully! 🎉")),
                      );
                    },
                    child: const Text("Book Now", style: TextStyle(color: Colors.white)),
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
