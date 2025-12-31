import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/design/design.dart';
import 'package:trip_plan/model/hotel_model.dart';

class AllPlaces extends StatefulWidget {
   AllPlaces({super.key});

  @override
  State<AllPlaces> createState() => _AllPlacesState();
}

class _AllPlacesState extends State<AllPlaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Places').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading places"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No places found"));
          }

          var places = snapshot.data!.docs;
          final placesmodel = snapshot.data!.docs
              .map((doc) => PlaceModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            padding: EdgeInsets.all(15.r),
            itemCount: places.length, // <-- SHOW ALL
            itemBuilder: (context, index) {
              var place = placesmodel[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Design(placedtl: place)),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.r),
                          bottomLeft: Radius.circular(15.r),
                        ),
                        child: Image.network(
                          "${place.image}",
                          width: 120.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // CONTENT
                      Expanded(
                        child: Padding(
                          padding:  EdgeInsets.all(12.0.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${place.place}",
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "${place.description}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[700]),
                              ),

                              SizedBox(height: 10.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "View Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, size: 16.sp, color: Colors.blue),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
