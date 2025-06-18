import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodprovision/foodorder.dart';
import 'package:foodprovision/orderlist.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class order extends StatefulWidget {
  final String foodname;
  final List image;
  final String pincode;
  final String postid;
  final String title;
  final String userid;
  order({
    super.key,
    required this.foodname,
    required this.image,
    required this.pincode,
    required this.postid,
    required this.title,
    required this.userid,
  });

  @override
  State<order> createState() => _OrderState();
}

class _OrderState extends State<order> {
  // User? user = FirebaseAuth.instance.currentUser;
  String inputText = '';
  Future<void> updatePostResponse(
    String currentUserName,
    String newStatus,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      SpinKitFadingCircle(size: 200, color: Colors.blueAccent);
      final docRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postid);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        String responseMessage = newStatus == 'accepted'
            ? 'Accepted by customer $currentUserName'
            : 'Rejected by customer $currentUserName';

        await docRef.update({
          "customeruid": widget.postid,
          'status': newStatus,
          'response': responseMessage,
          "customerlocation": inputText,
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final d = prefs.setString("userid", widget.userid);
        print("setusre>>$d");

        // Orderlist(postid: widget.postid);
        // await prefs.setString('action', 'Start');
        // print("docid>>${dk.postid}");
        print('Post updated successfully!');

        QuickAlert.show(
          backgroundColor: Colors.red,

          headerBackgroundColor: Colors.orange,
          context: context,
          type: QuickAlertType.success,
          title: 'send request to admin',
          text: 'wait for lobby page for confirmation',
          confirmBtnText: "ok",
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Orderlist(userid: widget.userid),
              ),
            );
          },
        );
      } else {
        print('No post found with this post ID');
      }
    } catch (e) {
      print('Error updating post response: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showInputDialog() {
    TextEditingController _controller = TextEditingController();
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter your Address'),
            content: TextField(
              minLines: 2,
              //  minLines: 1,//Normal textInputField will be displayed
              maxLines: 5,
              controller: _controller,
              decoration: InputDecoration(
                helperMaxLines: 2,
                labelText: 'location',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    inputText = _controller.text;
                    updatePostResponse("dk", "accepted");
                  });
                  Navigator.pop(context); // Close dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("e>>$e");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            // height: double.infinity,
            // color: Colors.blue,
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.deepOrange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Address: ${widget.foodname}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),

                        // Location Card
                        Container(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(16)),
                          // elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.food_bank_outlined,
                                  color: Colors.deepOrange,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "food: ${widget.title}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Pincode
                        Row(
                          children: [
                            Icon(
                              Icons.local_post_office,
                              color: Colors.deepOrange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Pincode: ${widget.pincode}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Image Gallery
                Container(
                  width: double.infinity,
                  // height: 800,
                  // color: Colors.orange,
                  child: Column(
                    children: [
                      const Text(
                        "Images",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.image.length,
                          itemBuilder: (context, i) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(86),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  widget.image[i],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Question
                      const Text(
                        "Do you want to take this order?",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Accept Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showInputDialog();
                            // updatePostResponse(user!.displayName!, "accepted");
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Accept Order",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
