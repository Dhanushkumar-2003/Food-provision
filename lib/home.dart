import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodprovision/foodDetail.dart';
import 'package:foodprovision/notification.dart';
import 'package:foodprovision/orderlist.dart';
import 'package:foodprovision/serverkey.dart';
import 'package:foodprovision/visibleorder.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String docid;
  const Home({super.key, required this.docid});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  bool _isListening = false;
  String _text = "Say 'Hello' to show the button!";
  bool _showButton = false;

  List<File> selectedImages = [];
  List<XFile> xfilePick = [];
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    xfilePick = pickedFile;
    print("xfilepick>>$xfilePick");
    if (selectedImages.length + xfilePick.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can select only up to 5 images')),
      );
      return;
    }

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  // Notifications notification = Notifications();
  // void initState() {
  //   super.initState();
  //   notification.initNotifications();
  //   notification.listenToForegroundMessages();
  //   notification.saveTokenToFirestore('');
  //   // Replace with dynamic user ID in real app
  // }

  Future<void> getPincodeAndSave() async {
    final docRef = FirebaseFirestore.instance
        .collection('fooduser')
        .doc(widget.docid);
    final docSnapshot = await docRef.get();
    print("docsnap>>$docSnapshot");
    try {
      final pincode = docSnapshot["pincode"];
      print("pincoede>>$pincode");
      if (docSnapshot.exists) {
        print("doc");
        final data = docSnapshot;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("pincode", pincode);

        print("Saved pincode: $pincode");
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print('line$e');
    }
  }

  @override
  void initState() {
    final ak = widget.docid;
    getPincodeAndSave();
    print("ak>>>>>>>>>>.$ak");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FOOD PROVISION"),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.orangeAccent, // Background color
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,

                  Colors.deepOrange,
                  // Colors.green.shade400,
                ],

                // Circular shape
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Orderlist(userid: ''),
                  ),
                );
              },
              icon: Icon(Icons.delivery_dining_outlined),
            ),
          ),
        ],
      ),

      body: Container(
        color: Colors.orange.shade50,
        margin: EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User Details Section
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF007AFF), Color(0xFFFFFFFF)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('fooduser')
                        .doc(widget.docid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          !snapshot.data!.exists) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!.data();

                      if (data == null) {
                        return Text("No user details available");
                      }
                      if (data.isNotEmpty) {
                        final datas = data['pincode'];
                        print("dataa>>>$datas");

                        return ClipPath(
                          // clipper: FoodWaveClipper(),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepOrange,

                                  Colors.deepOrange,
                                  // Colors.green.shade400,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            width: double.infinity,
                            height: 200,
                            padding: EdgeInsets.all(10),
                            // decoration: const BoxDecoration(
                            //   gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter,
                            //     colors: [
                            //       Color(0xFF007AFF),
                            //       Color(0xFFFFFFFF),
                            //     ],
                            //   ),
                            // ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User Details",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    data.containsKey("Image") &&
                                            data["Image"] != null
                                        ? CircleAvatar(
                                            radius: 40,
                                            backgroundImage: NetworkImage(
                                              data["Image"].toString(),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                    SizedBox(width: 20),
                                    Text(
                                      data.containsKey("username")
                                          ? data["username"]
                                          : "No username",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("userid");
                },
                child: Text("hv"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetail(docid: widget.docid),
                    ),
                  );
                },
                child: Text('donation time'),
              ),

              SizedBox(height: 20),

              Text("Your List", style: TextStyle(fontSize: 27)),

              // FirebaseFirestore.instance
              //   .collection('users')
              //   .doc(uid)
              //   .collection('posts')
              //   .snapshots();
              Container(
                color: Colors.red,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where("userid", isEqualTo: widget.docid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text("User data is loading...");
                    }

                    final data = snapshot.data?.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final doc = data[index];
                        final List<dynamic> images = doc['image'] ?? [];
                        final title = doc['title'] ?? 'No title';

                        return Container(
                          child: ClipPath(
                            clipper: FoodWaveClipper(),
                            child: Container(
                              height: 200,
                              margin: EdgeInsets.only(bottom: 10),
                              // margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade300,
                                    Colors.deepOrange.shade400,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),

                                // color: Colors.black,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                            width: 100,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: images.length,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Image.network(
                                                    images[i].toString(),
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          doc['response'] != null
                                              ? doc['adminconfirmation'] == null
                                                    ? Center(
                                                        child: ElevatedButton.icon(
                                                          onPressed: () {
                                                            var split;
                                                            String docs =
                                                                doc["response"];
                                                            split = docs.split(
                                                              'Accepted by customer',
                                                            );

                                                            print(
                                                              "akkk>>$split",
                                                            );
                                                            showModalBottomSheet(
                                                              context: context,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      top: Radius.circular(
                                                                        25.0,
                                                                      ),
                                                                    ),
                                                              ),
                                                              isScrollControlled:
                                                                  true,
                                                              builder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) {
                                                                    return DraggableScrollableSheet(
                                                                      expand:
                                                                          false,
                                                                      builder:
                                                                          (
                                                                            context,
                                                                            scrollController,
                                                                          ) {
                                                                            return SingleChildScrollView(
                                                                              controller: scrollController,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(
                                                                                  20.0,
                                                                                ),
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Center(
                                                                                      child: Container(
                                                                                        width: 50,
                                                                                        height: 5,
                                                                                        decoration: BoxDecoration(
                                                                                          color: Colors.grey[400],
                                                                                          borderRadius: BorderRadius.circular(
                                                                                            10,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 20,
                                                                                    ),
                                                                                    Center(
                                                                                      child: Text(
                                                                                        "Order Details",
                                                                                        style: TextStyle(
                                                                                          fontSize: 24,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: Colors.deepOrange,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 30,
                                                                                    ),
                                                                                    Row(
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.person,
                                                                                          color: Colors.deepOrange,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            "Customer Name: $split",
                                                                                            style: TextStyle(
                                                                                              fontSize: 18,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Icon(
                                                                                          Icons.location_on,
                                                                                          color: Colors.deepOrange,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            "Address: ${doc["customerlocation"]}",
                                                                                            style: TextStyle(
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 30,
                                                                                    ),
                                                                                    Center(
                                                                                      child: ElevatedButton.icon(
                                                                                        onPressed: () async {
                                                                                          try {
                                                                                            final docRef = FirebaseFirestore.instance
                                                                                                .collection(
                                                                                                  'posts',
                                                                                                )
                                                                                                .doc(
                                                                                                  doc.id,
                                                                                                );

                                                                                            final docSnapshot = await docRef.get();

                                                                                            if (docSnapshot.exists) {
                                                                                              await docRef.update(
                                                                                                {
                                                                                                  "adminconfirmation": "Your order is confirmed. Collect your food.",
                                                                                                },
                                                                                              );

                                                                                              print(
                                                                                                'Post updated successfully!',
                                                                                              );
                                                                                              Navigator.pop(
                                                                                                context,
                                                                                              ); // close bottom sheet
                                                                                            } else {
                                                                                              print(
                                                                                                'No post found with this ID.',
                                                                                              );
                                                                                            }
                                                                                          } catch (
                                                                                            e
                                                                                          ) {
                                                                                            print(
                                                                                              'Error updating post response: $e',
                                                                                            );
                                                                                          }
                                                                                        },
                                                                                        icon: const Icon(
                                                                                          Icons.check_circle,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                        label: const Text(
                                                                                          "Confirm Order",
                                                                                        ),
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Colors.deepOrange,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(
                                                                                              30,
                                                                                            ),
                                                                                          ),
                                                                                          padding: const EdgeInsets.symmetric(
                                                                                            horizontal: 32,
                                                                                            vertical: 14,
                                                                                          ),
                                                                                          textStyle: const TextStyle(
                                                                                            fontSize: 16,
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
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
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .food_bank_outlined,
                                                            color: Colors.white,
                                                          ),
                                                          label: const Text(
                                                            "confirm order",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            // padding: const EdgeInsets.symmetric(
                                                            //     horizontal: 24, vertical: 14),
                                                            backgroundColor:
                                                                Colors
                                                                    .deepOrange,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    30,
                                                                  ),
                                                            ),
                                                            textStyle:
                                                                const TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Center(
                                                          child: ElevatedButton.icon(
                                                            onPressed: () {
                                                              var split;
                                                              String docs =
                                                                  doc["response"];
                                                              split = docs.split(
                                                                'Accepted by customer',
                                                              );

                                                              print(
                                                                "akkk>>$split",
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              " order placed",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            style: ElevatedButton.styleFrom(
                                                              // padding: const EdgeInsets.symmetric(
                                                              //     horizontal: 24, vertical: 14),
                                                              backgroundColor:
                                                                  Colors.green,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      30,
                                                                    ),
                                                              ),
                                                              textStyle:
                                                                  const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                              : Container(),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "food: $title",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Text("Pincode: ${doc['pincode']}"),
                                            Text(
                                              "order:${doc['response'] ?? "waiting for reply"}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy Page for Navigation

class FoodWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.75);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.85,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
