import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 226, 239, 249)
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,size: 65,)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),

            // Owner Info
            const Text(
              "Alex Johnson",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Founder, Roads To Go ✈️",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 140),

            // Contact Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Icon(Icons.email_outlined, color: Colors.blueAccent),
                          SizedBox(width: 10),
                          Text(
                            "alex@roadstogo.com",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.phone_outlined, color: Colors.green),
                          SizedBox(width: 10),
                          Text(
                            "+91 98765 43210",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Bangalore, India",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.dashboard),
                      label: const Text("Dashboard"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 226, 239, 249),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class OwnerStat extends StatelessWidget {
  final String label;
  final String value;
  const OwnerStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}
