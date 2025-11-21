import 'package:flutter/material.dart';
import 'package:trip_plan/design/design.dart';

class HotelDetailsPage extends StatefulWidget {
  const HotelDetailsPage({super.key});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
              size: 28,
            ),
            onPressed: () => setState(() => isFav = !isFav),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Image.network(
            "https://www.thespruce.com/thmb/_xQMAqSNbX2bjnfXDKOdtaZRFaI=/2048x0/filters:no_upscale():max_bytes(150000):strip_icc()/put-together-a-perfect-guest-room-1976987-hero-223e3e8f697e4b13b62ad4fe898d492d.jpg", // 👈 Replace with your image
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Details Section
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black12,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Hotel Name
                      const Text(
                        "Royal Paradise Resort",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Location
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.redAccent, size: 18),
                          SizedBox(width: 5),
                          Text("Maldives", style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Rating and Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              Icon(Icons.star_half, color: Colors.amber, size: 20),
                              SizedBox(width: 6),
                              Text("4.5 (1.2k Reviews)",
                                  style: TextStyle(color: Colors.black54)),
                            ],
                          ),
                          Text("\$220 / night",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // About section
                      const Text(
                        "About Hotel",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "A luxury beachfront resort offering panoramic ocean views, "
                        "private villas, infinity pool, and premium dining experience. "
                        "Perfect getaway for couples and families.",
                        style: TextStyle(color: Colors.black87, height: 1.5),
                      ),
                      const SizedBox(height: 20),

                      // Meals section
                      const Text(
                        "Included Meals",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          _MealItem(icon: Icons.breakfast_dining, label: "Breakfast"),
                          _MealItem(icon: Icons.lunch_dining, label: "Lunch"),
                          _MealItem(icon: Icons.dinner_dining, label: "Dinner"),
                        ],
                      ),
                   

                    
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating Button
          Positioned(
            bottom: 30,
            left: 25,
            right: 25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Design()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Room Selected!")),
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Colors.indigo, Color(0xFFa8e063)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Select This Room",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Meal Item Widget
class _MealItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MealItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green.shade50,
          child: Icon(icon, color: Colors.green, size: 26),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}


