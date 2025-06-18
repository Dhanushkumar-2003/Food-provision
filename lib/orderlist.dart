import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodprovision/foodorder.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodprovision/foodorder.dart';
import 'package:foodprovision/foodorder.dart';
import 'package:foodprovision/login.dart';
import 'package:foodprovision/serverkey.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'foodorder.dart';

class Orderlist extends StatefulWidget {
  final String userid;
  const Orderlist({super.key, required this.userid});

  @override
  State<Orderlist> createState() => _OrderlistState();
}

class _OrderlistState extends State<Orderlist> {
  // Replace this with actual UID logic
  AceessServertoken access = AceessServertoken();
  String? userid;

  Future getid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString("userid")!;
    print("userid>>$userid");
    setState(() {});
  }

  @override
  void initState() {
    getid();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: userid == null
          ? Container(child: Text("you did not order yet"))
          : Container(
              color: Colors.orange.shade50,
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where("userid", isEqualTo: userid)
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

                  if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // ignore: non_constant_identifier_names
                          final String = access.serverKey();
                          print("string>>>$String");
                        },
                        child: Text("get"),
                      ),
                    );
                  }

                  final data = snapshot.data.docs;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final doc = data[index];
                      final List<dynamic> images = doc['image'] ?? [];
                      final title = doc['title'] ?? 'Untitled';
                      final location = doc["location"];
                      final confirm = doc["adminconfirmation"];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Images section
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (context, i) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        images[i].toString(),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Info section
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                confirm == null
                                    ? "⏳ Waiting for admin confirmation"
                                    : "✅ $confirm",
                                style: TextStyle(
                                  color: confirm == null
                                      ? Colors.grey
                                      : Colors.green,
                                  fontWeight: FontWeight.w500,
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
