import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/design.dart';
import '../model/hotel_model.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _PlacelistScreenState();
}

class _PlacelistScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _removeFavorite(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('favorites').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from favorites'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove favorite'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Row(
          children: [
            Icon(Icons.favorite, color: Colors.red[400], size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'My Favorites',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.red[400], strokeWidth: 3),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading favorites...',
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
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                      child: Icon(Icons.favorite_border, size: 80.sp, color: Colors.red[300]),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        'Start exploring and add places to your favorites to see them here',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey[500], height: 1.5),
                      ),
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                  child: Text(
                    '${placesmodel.length} ${placesmodel.length == 1 ? 'Place' : 'Places'}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Expanded(
                  child: GridView.builder(
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
                      final docId = places[index].id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Design(placedtl: subplaces)),
                          );
                        },
                        child: Hero(
                          tag: 'favorite_${subplaces.place}_$index',
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
                                              color: Colors.red[400],
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
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.7),
                                          ],
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
                                                Icons.favorite,
                                                color: Colors.red[300],
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                child: Text(
                                                  'Saved to favorites',
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

                                  // Remove from Favorites Button
                                  Positioned(
                                    top: 8.h,
                                    right: 8.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              title: Text(
                                                'Remove from Favorites?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                              content: Text(
                                                'Are you sure you want to remove "${subplaces.place}" from your favorites?',
                                                style: TextStyle(fontSize: 14.sp),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _removeFavorite(docId);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red[400],
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.r),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Remove',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.95),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red[500],
                                          size: 20.sp,
                                        ),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
