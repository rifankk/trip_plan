import 'package:flutter/material.dart';

class Booknow extends StatefulWidget {
  const Booknow({super.key});

  @override
  State<Booknow> createState() => _BookingPageState();
}

class _BookingPageState extends State<Booknow> {
  DateTime? startDate;
  DateTime? endDate;
  int guests = 2;
  String roomType = "Deluxe Room";
  bool airportPickup = false;
  bool includeMeals = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Your Trip"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✈️ Destination Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // 🗓️ Date Picker Section
            const Text(
              "Select Travel Dates",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                      );
                      if (date != null) setState(() => startDate = date);
                    },
                    child: _buildDateTile(
                      label: "Check-in",
                      value: startDate != null
                          ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                          : "Select Date",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                      );
                      if (date != null) setState(() => endDate = date);
                    },
                    child: _buildDateTile(
                      label: "Check-out",
                      value: endDate != null
                          ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                          : "Select Date",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 👥 Guests Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Guests",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (guests > 1) setState(() => guests--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text("$guests"),
                    IconButton(
                      onPressed: () {
                        setState(() => guests++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🏨 Room Type Dropdown
            const Text(
              "Select Room Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: roomType,
              items: const [
                DropdownMenuItem(value: "Deluxe Room", child: Text("Deluxe Room")),
                DropdownMenuItem(value: "Suite", child: Text("Suite")),
                DropdownMenuItem(value: "Luxury Villa", child: Text("Luxury Villa")),
              ],
              onChanged: (value) => setState(() => roomType = value!),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🧳 Add-ons
            const Text(
              "Additional Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: airportPickup,
              title: const Text("Airport Pickup & Drop"),
              onChanged: (value) => setState(() => airportPickup = value!),
            ),
            CheckboxListTile(
              value: includeMeals,
              title: const Text("Include Meals"),
              onChanged: (value) => setState(() => includeMeals = value!),
            ),

            const SizedBox(height: 30),

            // 💰 Price Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Price",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹12,499",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔘 Book Now Button
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Booking Confirmed!")),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
