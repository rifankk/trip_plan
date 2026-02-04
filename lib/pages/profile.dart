import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trip_plan/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Option 1: Get display name from Firebase Auth
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          setState(() {
            userName = user.displayName!;
            isLoading = false;
          });
        }
        // Option 2: Get name from Firestore
        else {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            setState(() {
              userName = userDoc.get('name') ?? 'User';
              isLoading = false;
            });
          } else {
            setState(() {
              userName = user.email?.split('@')[0] ?? 'User';
              isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          userName = 'Guest';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        userName = 'User';
        isLoading = false;
      });
    }
  }

  void openDialPad(String phoneNumber) async {
    final Uri dialUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(dialUri)) {
      await launchUrl(dialUri);
    } else {
      print("Could not launch dialer");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 🌄 Background header with gradient overlay
            Container(
              height: 240.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1526772662000-3f88f10405ff?auto=format&fit=crop&w=900&q=60",
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                ),
              ),
            ),

            // 🧍 Profile content
            Padding(
              padding: EdgeInsets.only(top: 180.h),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10.r, offset: Offset(0, -2)),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 70.h),
                    // Display user name from Firebase
                    isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                    SizedBox(height: 30.h),
                    Divider(thickness: 1, color: Colors.grey[200]),
                    SizedBox(height: 10.h),

                    // ⚙️ Options section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          _buildOption(
                            icon: Icons.help_outline,
                            text: "Help & Support",
                            color: Colors.purple,
                            onTap: () {
                              openDialPad("9747231196");
                            },
                          ),
                          _buildOption(
                            icon: Icons.logout,
                            text: "Logout",
                            color: Colors.redAccent,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    title: Text("Logout"),
                                    content: Text("Are you sure you want to logout?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        onPressed: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => Login()),
                                          );
                                        },
                                        child: Text("Logout"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),

            // 👤 Profile picture with edit button
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 120.h),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(radius: 60, child: Icon(Icons.person, size: 55)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Stats widget
  Widget _buildStat(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        SizedBox(height: 4),
        Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  // Option list tile widget
  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]),
      ],
    );
  }
}
