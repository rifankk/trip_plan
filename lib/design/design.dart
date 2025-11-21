import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:trip_plan/design/booknow.dart';
import 'package:trip_plan/design/entry.dart';

class Design extends StatefulWidget {
  final String? imageurl;
  const Design({super.key, this.imageurl});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  bool isFav = false;
  String selectedFilter = "Hotels";
  

  Map<String, dynamic>? selectedHotel; 
  final List<String> filters = ["Hotels", "Activities", "Meals"];
  List<String> selectedActivities = [];
  List<String> selectedMeals = []; // Tracks optional selected meals by title

  // NEW: State variable for total calculated price
  double totalPrice = 0.0;

  // Helper function to get all hotels
  List<Map<String, dynamic>> getAllHotels() =>
      [...lowestHotels, ...middleHotels, ...highestHotels];

  // --- NEW: Price Calculation Logic ---
  double _getHotelPrice(Map<String, dynamic>? hotel) {
    if (hotel == null) return 0.0;
    // Extract price string, remove currency/text, and parse to double
    String priceString = hotel['price'].toString().replaceAll(RegExp(r'[^\d.]'), '');
  
    return double.tryParse(priceString) ?? 0.0;
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    // Base Package Price (The ₹12,499 in the bottom bar, assumed constant for the package)
    const double basePackagePrice = 12499.0;
    total += basePackagePrice;

    // 1. Hotel Price Adjustment: Find the difference from the lowest hotel
    // We assume the base price includes the lowest hotel, so we only add the upgrade cost.
    double lowestHotelPrice = _getHotelPrice(lowestHotels.first);

    if (selectedHotel != null) {
        double selectedHotelPrice = _getHotelPrice(selectedHotel);
        // Add the difference in cost between the selected hotel and the lowest hotel 
        // (This correctly only adds the UPGRADE cost)
        double hotelAdjustment = selectedHotelPrice - lowestHotelPrice;
        if (hotelAdjustment > 0) {
            total += hotelAdjustment;
        }
    }

    // 2. Activities Price
    for (String activityName in selectedActivities) {
      final activity = activities.firstWhere(
          (a) => a['name'] == activityName,
          orElse: () => {"price": 0.0});
      total += activity["price"] as double; // Activities are all optional extras
    }

    // 3. Optional Meals Price
    // We only iterate over *optional* meals that were selected
    for (String mealTitle in selectedMeals) {
      final meal = meals.firstWhere(
          (m) => m['title'] == mealTitle,
          orElse: () => {"price": 0.0, "included": false});

      // IMPORTANT: Only add price if it's an optional meal that has a cost.
      if (meal["included"] == false && meal["price"] > 0) {
        total += meal["price"] as double;
      }
    }

    return total;
  }

  @override
  void initState() {
    super.initState();
   
    totalPrice = _calculateTotalPrice(); 

    for (var meal in meals) {
      if (meal["included"] == true) {
        selectedMeals.add(meal["title"]);
      }
    } 
  }
  
  // Use a custom setState wrapper to recalculate price every time the state changes
  @override
  void setState(VoidCallback fn) {
    super.setState(() {
      fn();
      totalPrice = _calculateTotalPrice();

    });
  }
  // ---------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 2),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFav = !isFav;
                });
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFav ? Colors.redAccent : Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌅 Main Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                widget.imageurl ??
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Main Details Section
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 243, 242, 242),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔸 Mini Photo Gallery (Original Code)
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              width: 95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://images.livemint.com/img/2023/01/14/original/mountain_environment_1673684710775.jpg",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Itinerary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                    const Text(
                      "Day Wise Details of your package",
                      style: TextStyle(fontSize: 13),
                    ),

                    // 🔹 Filter Buttons (Original Code)
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: filters
                          .map((f) => GestureDetector(
                                onTap: () => setState(() {
                                  selectedFilter = f;
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: selectedFilter == f
                                        ? Colors.indigo
                                        : Colors.white,
                                  ),
                                  child: Text(
                                    f,
                                    style: TextStyle(
                                      color: selectedFilter == f
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const Divider(),

                    if (selectedFilter == "Hotels") _buildHotels(),
                    if (selectedFilter == "Activities") _buildActivities(),
                    if (selectedFilter == "Meals") _buildMeals(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    

      // 📦 Bottom Button Section
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- UPDATED: Display Selected Items Summary ---
            _buildSelectionSummary(),
            // ------------------------------------------
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 5),
                    const Text("4.7",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                // --- NEW: Display Total Price ---
                Text(
                  "₹${totalPrice.toStringAsFixed(0)} / person",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 18),
                ),
                // --------------------------------
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Booknow()),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.indigo, Colors.cyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    "Book Now",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPDATED: Selection Summary Widget ---
  Widget _buildSelectionSummary() {
    // Only display if at least one item is selected in any category
    if (selectedHotel == null &&
        selectedActivities.isEmpty &&
        selectedMeals.isEmpty) {
      return const SizedBox.shrink();
    }

    // Prepare a list of summary strings
    List<String> summary = [];

    // 1. Hotel Summary
    if (selectedHotel != null) {
      // Calculate hotel price adjustment
      double selectedHotelPrice = _getHotelPrice(selectedHotel);
      double lowestHotelPrice = _getHotelPrice(lowestHotels.first);
      double hotelAdjustment = selectedHotelPrice - lowestHotelPrice;
      
      String priceText = hotelAdjustment > 0 
          ? " (Upgrade: +₹${hotelAdjustment.toStringAsFixed(0)})" 
          : " (Included)";

      summary.add("Hotel: ${selectedHotel!['name']}$priceText");
    }

    // 2. Activities Summary
    if (selectedActivities.isNotEmpty) {
      for (String activityName in selectedActivities) {
        final activity = activities.firstWhere(
            (a) => a['name'] == activityName,
            orElse: () => {"price": 0.0});
        String priceText = activity["price"] > 0
            ? " (Extra: +₹${activity["price"].toStringAsFixed(0)})"
            : "";
        summary.add("Activity: $activityName$priceText");
      }
    }

    // 3. Meals Summary
    // Display included meals (no extra cost)
    List<Map<String, dynamic>> includedMeals = meals
        .where((m) => m["included"] == true)
        .toList();
    for(final meal in includedMeals) {
        summary.add("Meal: ${meal["title"]} (Included)");
    }
    
    // Display selected optional meals
    List<Map<String, dynamic>> optionalSelectedMeals = meals
        .where((m) => m["included"] == false && selectedMeals.contains(m["title"]))
        .toList();
    for(final meal in optionalSelectedMeals) {
        String priceText = meal["price"] > 0
            ? " (Extra: +₹${meal["price"].toStringAsFixed(0)})"
            : "";
        summary.add("Meal: ${meal["title"]}$priceText");
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📝 Your Selections:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 5),
          ...summary.map((text) => Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  "• $text",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              )),
           Padding(
             padding:  EdgeInsets.symmetric(vertical: 8),
             child: DottedLine(dashColor: Colors.black38, dashGapLength: 4, lineThickness: 0.5,),
           ),
          Text(
            "💰 Base Price: ₹12,499",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Text(
            "✨ Total Price: ₹${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------

  Widget _buildHotels() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // 🔹 Tab Bar (Original Code)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black87,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.indigo,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              tabs: const [
                Tab(text: "Lowest"),
                Tab(text: "Middle"),
                Tab(text: "Highest"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 Important: Give fixed height and use Expanded inside a Flexible parent
          SizedBox(
            height: 280,
            child: TabBarView(
              children: [
                _hotelList(lowestHotels),
                _hotelList(middleHotels),
                _hotelList(highestHotels),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UPDATED: Hotel Data with Parsable Price ---
  final List<Map<String, dynamic>> lowestHotels = [
    {
      "id": 1,
      "name": "Budget Inn Goa",
      "location": "Baga Beach",
      "price": "₹2,499 / night",
      "rating": "4.0",
      "img":
          "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000"
    },
    {
      "id": 2,
      "name": "Casa Comfort Stay",
      "location": "Mapusa",
      "price": "₹3,199 / night",
      "rating": "4.2",
      "img":
          "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000"
    },
  ];

  final List<Map<String, dynamic>> middleHotels = [
    {
      "id": 3,
      "name": "The Tamarind Hotel",
      "location": "Anjuna",
      "price": "₹6,999 / night",
      "rating": "4.5",
      "img":
          "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000"
    },
  ];

  final List<Map<String, dynamic>> highestHotels = [
    {
      "id": 4,
      "name": "Taj Exotica Resort & Spa",
      "location": "Benaulim",
      "price": "₹18,499 / night",
      "rating": "4.9",
      "img":
          "https://images.unsplash.com/photo-1618773928121-c32242e63f39?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000"
    },
  ];
  // ---------------------------------------

  /// 🔸 Helper Widget for Reusable Hotel List (Original Logic, uses custom setState wrapper)
  Widget _hotelList(List<Map<String, dynamic>> _hotelList) {
    return ListView.builder(
      itemCount: _hotelList.length,
      padding: const EdgeInsets.only(top: 5),
      itemBuilder: (context, index) {
        final h = _hotelList[index];
        // Check if this hotel is the currently selected one
        bool isChecked = selectedHotel?['id'] == h['id'];

        return GestureDetector(
          onTap: () {
            // NOTE: Original code goes to Entry(), maintaining that behavior
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HotelDetailsPage()),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // hotel image (Original Code)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      h["img"]!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // hotel info (name, location, price) (Original Code)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h["name"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          h["location"]!,
                          style: const TextStyle(color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          h["price"]!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // rating + checkbox on right (Original Logic)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 3),
                          Text(
                            h["rating"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Use the main setState to update selectedHotel
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              // Select this hotel
                              selectedHotel = h;
                            } else {
                              // Deselect only if it was the current one
                              if (selectedHotel?['id'] == h['id']) {
                                selectedHotel = null;
                              }
                            }
                          });
                        },
                        visualDensity: const VisualDensity(
                            horizontal: -4, vertical: -4),
                        activeColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- UPDATED: Activities Data with Price ---
  final List<Map<String, dynamic>> activities = [
    {
      "icon": Icons.surfing,
      "name": "Water Sports",
      "desc": "Banana ride, Jet Ski, Parasailing",
      "price": 1500.0, // Added price
    },
    {
      "icon": Icons.hiking,
      "name": "Nature Trekking",
      "desc": "Discover hidden waterfalls and trails",
      "price": 500.0, // Added price
    },
    {
      "icon": Icons.spa,
      "name": "Spa & Relaxation",
      "desc": "Beachside spa and wellness activities",
      "price": 2500.0, // Added price
    },
    {
      "icon": Icons.restaurant,
      "name": "Food Tour",
      "desc": "Local Goan seafood tasting experience",
      "price": 800.0, // Added price
    },
  ];

  // 🏄 Activities Section with Checkboxes (Updated to show price)
  Widget _buildActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          "Choose Your Activities",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...activities.map((activity) {
          bool isSelected =
              selectedActivities.contains(activity["name"]); // check if selected
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: CheckboxListTile(
              activeColor: Colors.blueAccent,
              value: isSelected,
              onChanged: (bool? value) {
                // Use the main setState to update selectedActivities
                setState(() {
                  if (value == true) {
                    selectedActivities.add(activity["name"]);
                  } else {
                    selectedActivities.remove(activity["name"]);
                  }
                });
              },
              title: Text(activity["name"]),
              subtitle: Text(
                  "${activity["desc"]} (Extra: ₹${activity["price"].toStringAsFixed(0)})"), // Show price
              secondary: Icon(activity["icon"], color: Colors.blueAccent),
            ),
          );
        }).toList(),
        const SizedBox(height: 10),
        if (selectedActivities.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Selected: ${selectedActivities.join(', ')}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              ),
            ),
          ),
      ],
    );
  }

  // --- UPDATED: Meals Data with Price ---
  final List<Map<String, dynamic>> meals = [
    {
      "icon": Icons.breakfast_dining,
      "title": "Breakfast Buffet",
      "desc": "Continental + Goan dishes with coffee & juice",
      "time": "7:00 AM - 10:00 AM",
      "included": true,
      "price": 0.0,
    },
    {
      "icon": Icons.lunch_dining,
      "title": "Goan Lunch Thali",
      "desc": "Traditional seafood and vegetarian options",
      "time": "12:30 PM - 2:30 PM",
      "included": true,
      "price": 0.0,
    },
    {
      "icon": Icons.dinner_dining,
      "title": "Beachside Candlelight Dinner",
      "desc": "Optional romantic dinner setup",
      "time": "7:00 PM - 10:00 PM",
      "included": false,
      "price": 1800.0, // Added price
    },
    {
      "icon": Icons.emoji_food_beverage,
      "title": "Evening Tea & Snacks",
      "desc": "Assorted pastries and masala chai",
      "time": "5:00 PM - 6:00 PM",
      "included": false,
      "price": 350.0, // Added price
    },
  ];

  // 🍽 Meals Section with Checkboxes (Updated to show price)
  Widget _buildMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🍽 Meals & Dining Options",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 8),
        const Text(
          "Select your meal preferences and add optional experiences",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 12),

        // List of meals
        ...meals.map((meal) {
          bool selected = selectedMeals.contains(meal["title"]);
          bool isIncluded = meal["included"];
          String priceText = meal["price"] > 0
              ? " (Extra: ₹${meal["price"].toStringAsFixed(0)})"
              : isIncluded
                  ? " (Included)"
                  : "";

          return Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: CheckboxListTile(
              activeColor: Colors.blueAccent,
              // Value is true if included OR explicitly selected
              value: isIncluded || selected,
              // Cannot change included meals, only optional ones
              onChanged: isIncluded
                  ? null // included meals cannot be unchecked
                  : (bool? value) {
                      // Use the main setState to update selectedMeals
                      setState(() {
                        if (value == true) {
                          selectedMeals.add(meal["title"]);
                        } else {
                          selectedMeals.remove(meal["title"]);
                        }
                      });
                    },
              title: Text(meal["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal["desc"]),
                  Text("⏰ ${meal["time"]}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (isIncluded)
                    const Text("INCLUDED",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold))
                  else
                    Text(priceText.trim(),
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                ],
              ),
              secondary: Icon(meal["icon"], color: Colors.orangeAccent),
            ),
          );
        }).toList(),

        const SizedBox(height: 10),

        // 🌿 Dietary Preferences (using local StatefulBuilder, this is fine)
        const Text(
          "Dietary Preferences",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildChip("Vegetarian"),
            _buildChip("Vegan"),
            _buildChip("Gluten-Free"),
            _buildChip("Seafood Lover"),
          ],
        ),

        const SizedBox(height: 20),

        if (selectedMeals.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "✅ Added meals: ${selectedMeals.join(', ')}",
              style: const TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  /// Helper chip widget (Original Code)
  Widget _buildChip(String label) {
    bool selected = false;
    return StatefulBuilder(builder: (context, setState) {
      return ChoiceChip(
        label: Text(label),
        labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600),
        selectedColor: Colors.blueAccent,
        backgroundColor: Colors.grey[200],
        selected: selected,
        onSelected: (value) {
          setState(() {
            selected = value;
          });
        },
      );
    });
  }

 
}