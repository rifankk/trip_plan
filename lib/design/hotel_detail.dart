import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/model/hotel_model.dart';

class HotelDetailsPage extends StatefulWidget {
  Hotel? hotel;
  HotelDetailsPage({super.key, this.hotel});

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> with SingleTickerProviderStateMixin {
  bool isFav = false;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late List<String> hotelImages = [widget.hotel?.image1 ?? "", widget.hotel?.image2 ?? ""];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.forward();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated Carousel
          SizedBox(
            height: 380.h,
            child: PageView.builder(
              controller: _pageController,
              itemCount: hotelImages.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeInOut.transform(value) * 380,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.network(
                        hotelImages[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Page Indicators
          Positioned(
            top: 340.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                hotelImages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.h),
                  width: _currentPage == index ? 24 : 8,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                  ),
                ),
              ),
            ),
          ),

          // Details Section
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.58,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag Handle
                        Center(
                          child: Container(
                            width: 50.w,
                            height: 5.w,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Hotel Name with Badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${widget.hotel!.hotel}",
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.amber.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.verified, color: Colors.amber, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Verified",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // Rating and Price Card
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.indigo.shade50, Colors.purple.shade50],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.indigo.shade100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 22.sp),
                                      Icon(Icons.star, color: Colors.amber, size: 22.sp),
                                      Icon(Icons.star, color: Colors.amber, size: 22.sp),
                                      Icon(Icons.star, color: Colors.amber, size: 22.sp),
                                      Icon(Icons.star_half, color: Colors.amber, size: 22.sp),
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "4.5 (1.2k Reviews)",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // About section with icon
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.indigo, size: 22.sp),
                            SizedBox(width: 8.h),
                            Text(
                              "About Hotel",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "${widget.hotel!.description}",
                          style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15),
                        ),
                        SizedBox(height: 24),

                        // Meals section
                        Row(
                          children: [
                            Icon(Icons.restaurant_menu, color: Colors.indigo, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Included Meals",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.indigo,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MealItem(icon: Icons.breakfast_dining, label: "Breakfast"),
                            _MealItem(icon: Icons.lunch_dining, label: "Lunch"),
                            _MealItem(icon: Icons.dinner_dining, label: "Dinner"),
                          ],
                        ),

                        SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Amenity Chip Widget
class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  _AmenityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.indigo, size: 18),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.indigo),
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
  _MealItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.green, size: 28),
          ),
          SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
