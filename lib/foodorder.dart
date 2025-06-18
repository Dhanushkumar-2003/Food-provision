import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodprovision/visibleorder.dart';

class foodOrder extends StatefulWidget {
  final String pincode;
  final String docid;
  const foodOrder({super.key, required this.pincode, required this.docid});

  @override
  State<foodOrder> createState() => _foodOrderState();
}

// final uid = FirebaseAuth.instance.currentUser;

var pincode;
// ignore: prefer_typing_uninitialized_variables
var data;
// final user = FirebaseAuth.instance.currentUser;
// final user = DateTime.now();

class _foodOrderState extends State<foodOrder> {
  Future<String?> getCurrentUserPincode() async {
    try {
      // final user = FirebaseAuth.instance.currentUser;
      // print('user>>$user');
      // if (user == null) return null;

      final doc = await FirebaseFirestore.instance
          .collection('fooduser')
          .doc(widget.docid)
          .get();

      if (doc.exists) {
        data = doc.data() as Map<String, dynamic>;
        print("data>>${data["pincode"]}");
        // pincode = data["pincode"];
        // print("pincode>>>$pincode");
        return data['pincode'];
      }
      return null;
    } catch (e) {
      print("error>>>$e");
    }
  }

  @override
  void initState() {
    getCurrentUserPincode();

    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Your Food 🍱'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 4,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<String?>(
          stream: Stream.fromFuture(getCurrentUserPincode()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Pincode not found."));
            }

            final pincode = snapshot.data!;
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where("status", isEqualTo: 'pending')
                  // .where('userid', isNotEqualTo: widget.docid.toString())
                  .where("pincode", isEqualTo: pincode)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Loading delicious posts..."),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data.docs.isEmpty) {
                  return const Center(
                    child: Text("No food orders found in your area."),
                  );
                }

                final data = snapshot.data.docs;
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.6,
                        ),
                    itemBuilder: (context, index) {
                      final doc = data[index];
                      final List<dynamic> images = doc['image'] ?? [];
                      final title = doc['title'] ?? 'Untitled';
                      final location = doc["location"];
                      final userPincode = doc["pincode"];
                      final userid = doc['userid'];
                      print("docid>>>>>${doc.id}");
                      return Container(
                        child: GestureDetector(
                          onTap: () {},
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Image
                                if (images.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        images[0],
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                // Text Content
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.food_bank_outlined,
                                              size: 16,
                                              color: Colors.deepOrange,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "food:  $title",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            size: 16,
                                            color: Colors.deepOrange,
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              "location: $location",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => order(
                                              postid: doc.id,
                                              foodname: location,
                                              pincode: userPincode,
                                              image: images,
                                              title: title,
                                              userid: userid,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "click",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 24, vertical: 14),
                                        backgroundColor: Colors.deepOrange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            );
          },
        ),
      ),
    );
  }
}
