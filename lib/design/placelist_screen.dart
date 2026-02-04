import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/design.dart';
import '../model/hotel_model.dart';

class PlacelistScreen extends StatefulWidget {
  PlacelistScreen({super.key, required this.mainplaceid});
  String mainplaceid;
  @override
  State<PlacelistScreen> createState() => _PlacelistScreenState();
}

class _PlacelistScreenState extends State<PlacelistScreen> {
  @override
  void initState() {
    log(widget.mainplaceid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Text(
          'Explore Places',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Places')
              .where('status', isEqualTo: 1)
              .where('mainplace.id', isEqualTo: widget.mainplaceid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue[700], strokeWidth: 3),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading places...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.explore_off_rounded, size: 80.sp, color: Colors.grey[400]),
                    SizedBox(height: 16.h),
                    Text(
                      'No places found',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Check back later for new destinations',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            // Log data as JSON
            log(snapshot.data!.docs.map((doc) => doc.data()).toString());

            final places = snapshot.data!.docs;
            log(places.toString());
            final placesmodel = snapshot.data!.docs
                .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            return GridView.builder(
              itemCount: placesmodel.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final subplaces = placesmodel[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Design(placedtl: subplaces)),
                    );
                  },
                  child: Hero(
                    tag: 'place_${subplaces.place}_$index',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Stack(
                          children: [
                            // Background Image
                            Positioned.fill(
                              child: Image.network(
                                subplaces.image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image_not_supported,
                                      size: 50.sp,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Gradient Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                    stops: [0.5, 1.0],
                                  ),
                                ),
                              ),
                            ),

                            // Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subplaces.place ?? 'Unknown Place',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.5),
                                            offset: Offset(0, 1),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white.withOpacity(0.9),
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            'Tap to explore',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
