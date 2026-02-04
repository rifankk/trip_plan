import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/booknow.dart';
import 'package:trip_plan/design/hotel_detail.dart';
import 'package:trip_plan/model/hotel_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Design extends StatefulWidget {
  final PlaceModel? placedtl;

  const Design({super.key, this.placedtl});

  @override
  State<Design> createState() => _DesignState();
}

class _DesignState extends State<Design> {
  bool isFav = false;
  String selectedFilter = "Hotels";

  Hotel? selectedHotel;
  final List<String> filters = ["Hotels", "Activities", "Meals", "Nearby"];
  List<String> selectedActivities = [];
  List<String> selectedMeals = [];
  List<String> selectedtemple = [];

  // State variable for total calculated price
  double totalPrice = 0.0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> openGoogleMap(double latitude, double longitude) async {
    final Uri url = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    super.initState();

    // Don't pre-select meals - let user choose
    // selectedMeals starts empty

    // Don't auto-select hotel - let user choose
    // selectedHotel starts as null

    // Calculate initial total price
    totalPrice = _calculateTotalPrice();
    _checkIfFavorite();
  }

  double _getHotelPrice(Hotel? hotel) {
    if (hotel == null) return 0.0;
    if (hotel.pricePerday is String) {
      String priceString = hotel.pricePerday as String;
      priceString = priceString.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(priceString) ?? 0.0;
    } else if (hotel.pricePerday is double) {
      return hotel.pricePerday as double;
    } else if (hotel.pricePerday is int) {
      return (hotel.pricePerday as int).toDouble();
    }
    return 0.0;
  }

  double _calculateTotalPrice() {
    double total = 0.0;

    // 1. Start with base package price
    double basePackagePrice = double.tryParse(widget.placedtl?.basePackagePrice ?? '0') ?? 0.0;
    total += basePackagePrice;

    // 2. Add full hotel price if a hotel is selected
    if (selectedHotel != null) {
      double selectedHotelPrice = _getHotelPrice(selectedHotel);
      total += selectedHotelPrice;
    }

    // 3. Add selected activities prices
    if (widget.placedtl?.activity != null && selectedActivities.isNotEmpty) {
      for (String activityName in selectedActivities) {
        final activity = widget.placedtl!.activity!.firstWhere(
          (a) => a.title == activityName,
          orElse: () => Activity(price: "0"),
        );

        double activityPrice = 0.0;
        if (activity.price != null && activity.price!.isNotEmpty) {
          String priceStr = activity.price!.replaceAll(RegExp(r'[^\d.]'), '');
          activityPrice = double.tryParse(priceStr) ?? 0.0;
        }
        total += activityPrice;
      }
    }

    // 4. Add selected meal prices
    if (widget.placedtl?.meals != null && selectedMeals.isNotEmpty) {
      for (String mealTitle in selectedMeals) {
        final meal = widget.placedtl!.meals!.firstWhere(
          (m) => m.title == mealTitle,
          orElse: () => Meal(price: "0"),
        );

        double mealPrice = 0.0;
        if (meal.price != null && meal.price!.isNotEmpty) {
          String priceStr = meal.price!.replaceAll(RegExp(r'[^\d.]'), '');
          mealPrice = double.tryParse(priceStr) ?? 0.0;
        }
        total += mealPrice;
      }
    }

    return total;
  }

  // Recalculate total price whenever selections change
  void _updateTotalPrice() {
    setState(() {
      totalPrice = _calculateTotalPrice();
    });
  }

  // Check if place is already in favorites
  Future<void> _checkIfFavorite() async {
    if (widget.placedtl == null) return;

    try {
      final querySnapshot = await firestore
          .collection('favorites')
          .where('place', isEqualTo: widget.placedtl?.place)
          .limit(1)
          .get();

      if (mounted) {
        setState(() {
          isFav = querySnapshot.docs.isNotEmpty;
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  // Toggle favorite status
  Future<void> _toggleFavorite() async {
    if (widget.placedtl == null) return;

    try {
      if (isFav) {
        // Remove from favorites
        final querySnapshot = await firestore
            .collection('favorites')
            .where('place', isEqualTo: widget.placedtl?.place)
            .limit(1)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        if (mounted) {
          setState(() {
            isFav = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Removed from favorites')));
        }
      } else {
        // Add to favorites
        await firestore.collection('favorites').add(widget.placedtl!.toJson());

        if (mounted) {
          setState(() {
            isFav = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to favorites')));
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w, bottom: 2.h),
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border_outlined,
                color: isFav ? Colors.redAccent : Colors.white,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
              child: Image.network(
                widget.placedtl?.image ??
                    widget.placedtl?.mainplace?.imageUrl ??
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Main Details Section
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 243, 242, 242),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28.r),
                  topRight: Radius.circular(28.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mini Photo Gallery
                    SizedBox(
                      height: 60.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: Container(
                              width: 95.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.placedtl?.image2 ??
                                        widget.placedtl?.image ??
                                        "https://images.livemint.com/img/2023/01/14/original/mountain_environment_1673684710775.jpg",
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20.h),
                    Text(
                      widget.placedtl?.place ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text("Day Wise Details of your package", style: TextStyle(fontSize: 13.sp)),

                    // Filter Buttons
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: filters
                          .map(
                            (f) => GestureDetector(
                              onTap: () => setState(() {
                                selectedFilter = f;
                              }),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 15.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedFilter == f ? Colors.indigo : Colors.white,
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: selectedFilter == f ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    Divider(),

                    if (selectedFilter == "Hotels") _buildHotels(),
                    if (selectedFilter == "Activities") _buildActivities(),
                    if (selectedFilter == "Meals") _buildMeals(),
                    if (selectedFilter == "Nearby") _buildnearby(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total Price",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                    ),
                    Text(
                      "₹${totalPrice.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _showSelectionSummaryBottomSheet(context);
                  },
                  child: Container(
                    height: 60.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.indigo, Colors.cyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Text(
                        "View Detail",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectionSummaryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Indicator
              Container(
                height: 5.h,
                width: 50.w,
                margin: EdgeInsets.only(bottom: 15.h),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              /// Selection Summary
              _buildSelectionSummary(),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  // Selection Summary Widget - FIXED VERSION
  Widget _buildSelectionSummary() {
    List<String> summary = [];
    double basePrice = double.tryParse(widget.placedtl?.basePackagePrice ?? '0') ?? 0.0;
    double additionalCosts = 0.0;

    // 1. Hotel Summary - full price is additional
    if (selectedHotel != null) {
      double selectedHotelPrice = _getHotelPrice(selectedHotel);

      if (selectedHotelPrice > 0) {
        summary.add(
          "🏨 Hotel: ${selectedHotel?.hotel} (+₹${selectedHotelPrice.toStringAsFixed(0)})",
        );
        additionalCosts += selectedHotelPrice;
      } else {
        summary.add("🏨 Hotel: ${selectedHotel?.hotel}");
      }
    } else {
      summary.add("🏨 Hotel: Not selected");
    }

    // 2. Activities Summary - all activities are additional
    if (selectedActivities.isNotEmpty && widget.placedtl?.activity != null) {
      for (String activityName in selectedActivities) {
        final activity = widget.placedtl!.activity!.firstWhere(
          (a) => a.title == activityName,
          orElse: () => Activity(price: "0"),
        );

        double activityPrice = 0.0;
        if (activity.price != null && activity.price!.isNotEmpty) {
          String priceStr = activity.price!.replaceAll(RegExp(r'[^\d.]'), '');
          activityPrice = double.tryParse(priceStr) ?? 0.0;
        }

        String priceText = activityPrice > 0
            ? " (+₹${activityPrice.toStringAsFixed(0)})"
            : " (Free)";
        summary.add("🎯 Activity: $activityName$priceText");

        if (activityPrice > 0) {
          additionalCosts += activityPrice;
        }
      }
    }

    // 3. Meals Summary - add prices when selected
    if (selectedMeals.isNotEmpty && widget.placedtl?.meals != null) {
      for (String mealTitle in selectedMeals) {
        final meal = widget.placedtl!.meals!.firstWhere(
          (m) => m.title == mealTitle,
          orElse: () => Meal(price: "0"),
        );

        double mealPrice = 0.0;
        if (meal.price != null && meal.price!.isNotEmpty) {
          String priceStr = meal.price!.replaceAll(RegExp(r'[^\d.]'), '');
          mealPrice = double.tryParse(priceStr) ?? 0.0;
        }

        String priceText = mealPrice > 0 ? " (+₹${mealPrice.toStringAsFixed(0)})" : " (Included)";
        summary.add("🍽️ Meal: $mealTitle$priceText");

        if (mealPrice > 0) {
          additionalCosts += mealPrice;
        }
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📝 Your Package Summary",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),

          // Display all selections
          if (summary.isEmpty)
            Text(
              "No selections made yet",
              style: TextStyle(fontSize: 13.sp, color: Colors.black54),
            )
          else
            ...summary.map(
              (text) => Padding(
                padding: EdgeInsets.only(top: 4.0.h),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.w),
            child: DottedLine(dashColor: Colors.black38, dashGapLength: 4, lineThickness: 0.5),
          ),

          // Price Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Base Package:",
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
              ),
              Text(
                "₹${basePrice.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          if (additionalCosts > 0) ...[
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Additional Items:",
                  style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                ),
                Text(
                  "+₹${additionalCosts.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],

          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: DottedLine(dashColor: Colors.black38, dashGapLength: 4, lineThickness: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "💰 Total Price:",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                "₹${totalPrice.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHotels() {
    // Use hotels from the model
    final hotels = widget.placedtl?.hotels ?? [];

    if (hotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, size: 50.sp, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            Text("No hotels available", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black87,
              labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
              ),
              indicatorPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
              tabs: [
                Tab(text: "Lowest"),
                Tab(text: "Middle"),
                Tab(text: "Highest"),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          SizedBox(
            height: 280.h,
            child: TabBarView(
              children: [
                _hotelList(hotels.where((h) => h.filter?.toLowerCase() == 'lowest').toList()),
                _hotelList(hotels.where((h) => h.filter?.toLowerCase() == 'middle').toList()),
                _hotelList(hotels.where((h) => h.filter?.toLowerCase() == 'highest').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hotel List
  Widget _hotelList(List<Hotel> filteredHotels) {
    if (filteredHotels.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, size: 50.sp, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            Text("No hotels in this category", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredHotels.length,
      padding: EdgeInsets.only(top: 5.h),
      itemBuilder: (context, index) {
        final h = filteredHotels[index];
        bool isChecked = selectedHotel?.id == h.id;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HotelDetailsPage(hotel: h)),
            );
          },
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            elevation: 3,
            child: Container(
              padding: EdgeInsets.all(8.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(
                      h.image1?.isNotEmpty == true
                          ? h.image1!
                          : h.image2?.isNotEmpty == true
                          ? h.image2!
                          : 'https://via.placeholder.com/80',
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80.w,
                        height: 80.h,
                        color: Colors.grey[200],
                        child: Icon(Icons.hotel, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.h),

                  // Hotel info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.hotel ?? 'Unnamed Hotel',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          h.description ?? 'No description available',
                          style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              "₹${h.pricePerday ?? '0'}",
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                              decoration: BoxDecoration(
                                color: _getFilterColor(h.filter ?? ''),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                (h.filter ?? '').toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Checkbox
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 6.h),
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedHotel = h;
                            } else {
                              // Allow deselecting hotel
                              selectedHotel = null;
                            }
                            // Recalculate total price when hotel selection changes
                            _updateTotalPrice();
                          });
                        },
                        activeColor: Colors.indigo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
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

  Color _getFilterColor(String filter) {
    switch (filter.toLowerCase()) {
      case 'lowest':
        return Colors.green;
      case 'middle':
        return Colors.orange;
      case 'highest':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActivities() {
    // Use activities from the model
    final activitiesList = widget.placedtl?.activity ?? [];

    if (activitiesList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag, size: 50.sp, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            Text("No activities available", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Text(
          "Choose Your Activities",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),

        ...activitiesList.map((activity) {
          bool isSelected = selectedActivities.contains(activity.title);

          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 6.w),
            child: CheckboxListTile(
              activeColor: Colors.blueAccent,
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true && activity.title != null) {
                    selectedActivities.add(activity.title!);
                  } else if (activity.title != null) {
                    selectedActivities.remove(activity.title!);
                  }
                  // Recalculate total price when activity selection changes
                  _updateTotalPrice();
                });
              },
              title: Text(activity.title ?? 'No Name'),
              subtitle: Text(
                "${activity.description ?? 'No description'} (Extra: ₹${activity.price ?? '0'})",
              ),
              secondary: Icon(_getActivityIcon(activity.title), color: Colors.blueAccent),
            ),
          );
        }).toList(),

        SizedBox(height: 10.h),
        if (selectedActivities.isNotEmpty)
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Selected: ${selectedActivities.join(', ')}",
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
            ),
          ),
      ],
    );
  }

  Widget _buildMeals() {
    // Use meals from the model
    final mealsList = widget.placedtl?.meals ?? [];

    if (mealsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 50.sp, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            Text("No meals available", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🍽 Meals & Dining Options",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(height: 8.h),
        Text("Select your meal preferences", style: TextStyle(color: Colors.black54)),
        SizedBox(height: 12.h),

        ...mealsList.map((meal) {
          bool selected = selectedMeals.contains(meal.title);

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            margin: EdgeInsets.symmetric(vertical: 6.w),
            child: CheckboxListTile(
              activeColor: Colors.blueAccent,
              value: selected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true && meal.title != null) {
                    selectedMeals.add(meal.title!);
                  } else if (meal.title != null) {
                    selectedMeals.remove(meal.title!);
                  }
                  // Recalculate total price when meal selection changes
                  _updateTotalPrice();
                });
              },
              title: Text(meal.title ?? 'Meal', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.items ?? meal.title ?? ""),
                  if (meal.time != null && meal.time!.isNotEmpty)
                    Text(
                      "⏰ ${meal.time!}",
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                  Builder(
                    builder: (context) {
                      double mealPrice = 0.0;
                      if (meal.price != null && meal.price!.isNotEmpty) {
                        String priceStr = meal.price!.replaceAll(RegExp(r'[^\d.]'), '');
                        mealPrice = double.tryParse(priceStr) ?? 0.0;
                      }

                      if (mealPrice > 0) {
                        return Text(
                          "₹${mealPrice.toStringAsFixed(0)}",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          "Included",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              secondary: Icon(_getMealIcon(meal.title), color: Colors.orangeAccent),
            ),
          );
        }).toList(),

        SizedBox(height: 20.h),
        if (selectedMeals.isNotEmpty)
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              "✅ Selected meals: ${selectedMeals.join(', ')}",
              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildnearby() {
    // Use nearby places from the model
    final nearbylist = widget.placedtl?.nearby ?? [];

    if (nearbylist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 50.sp, color: Colors.grey[300]),
            SizedBox(height: 10.h),
            Text("No nearby places available", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          "📍 Nearby Places",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),

        ...nearbylist.map((nearby) {
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 6.w),
            child: ListTile(
              leading: Icon(Icons.place, color: Colors.indigo),
              title: Text(nearby.title ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(Icons.location_on, color: Colors.red),
                onPressed: () {
                  if (nearby.lat != null && nearby.log != null) {
                    openGoogleMap(nearby.lat!, nearby.log!);
                  }
                },
              ),
            ),
          );
        }).toList(),

        SizedBox(height: 10.h),
      ],
    );
  }

  IconData _getActivityIcon(String? activityName) {
    if (activityName == null) return Icons.flag;

    final name = activityName.toLowerCase();
    if (name.contains('surf') || name.contains('water')) return Icons.surfing;
    if (name.contains('hike') || name.contains('trek')) return Icons.hiking;
    if (name.contains('spa') || name.contains('relax')) return Icons.spa;
    if (name.contains('food') || name.contains('dining')) return Icons.restaurant;
    return Icons.flag;
  }

  IconData _getMealIcon(String? mealName) {
    if (mealName == null) return Icons.restaurant;

    final name = mealName.toLowerCase();
    if (name.contains('breakfast')) return Icons.breakfast_dining;
    if (name.contains('lunch')) return Icons.lunch_dining;
    if (name.contains('dinner')) return Icons.dinner_dining;
    if (name.contains('tea') || name.contains('snack')) return Icons.emoji_food_beverage;
    return Icons.restaurant;
  }
}
