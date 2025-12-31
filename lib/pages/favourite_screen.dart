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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No sub places yet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4, // adjust tile size
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
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // image
                        Container(
                          height: 170.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.r),
                              topRight: Radius.circular(15.r),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(subplaces.image ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // name
                        Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Text(
                            subplaces.place ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 16.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
