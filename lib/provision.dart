import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class provision extends StatefulWidget {
  const provision({super.key});

  @override
  State<provision> createState() => _provisionState();
}

class _provisionState extends State<provision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('userpincode')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
              // Show loader until data arrives
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return Text("User data  is loading");
            }
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(child: Text(snapshot.data[index][""]));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
