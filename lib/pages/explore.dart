import 'package:flutter/material.dart';
import 'package:trip_plan/design/design.dart'; // link to your detail page

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<Explore> {
  final List<String> categories = [
    "All",
    "Beaches",
    "Hills",
    "Adventure",
    "Cities",
    "Historical"
  ];

  String selectedCategory = "All";

  final List<Map<String, String>> destinations = [
    {
      "name": "Goa",
      "category": "Beaches",
      "image":
          "https://study.com/cimages/multimages/16/eiffel_tower.jpg",
      "desc": "Golden sands, coconut trees & nightlife"
    },
    {
      "name": "Manali",
      "category": "Hills",
      "image":
          "https://study.com/cimages/multimages/16/eiffel_tower.jpg",
      "desc": "Snowy mountains and cozy stays"
    },
    {
      "name": "Rajasthan",
      "category": "Historical",
      "image":
          "https://study.com/cimages/multimages/16/eiffel_tower.jpg",
      "desc": "Desert palaces and royal forts"
    },
    {
      "name": "Andaman",
      "category": "Adventure",
      "image":
          "https://study.com/cimages/multimages/16/eiffel_tower.jpg",
      "desc": "Scuba diving & coral reefs"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // filter logic
    final filtered = selectedCategory == "All"
        ? destinations
        : destinations
            .where((d) => d["category"] == selectedCategory)
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
     
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // 🔹 Category Chips
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final selected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 6)
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // 🌍 Destination Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final dest = filtered[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Design(imageurl: dest["image"]),
                      ),
                    );
                  },
                  child: Hero(
  tag: '${dest["image"]}-$index', // 👈 now unique even if images repeat
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.network(dest["image"]!, fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dest["name"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                dest["desc"]!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
)

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
