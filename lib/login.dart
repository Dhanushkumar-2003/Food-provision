import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodprovision/bottomnav.dart';
import 'package:foodprovision/foodorder.dart';
import 'package:foodprovision/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _HomeState();
}

var dk;

class _HomeState extends State<Login> {
  File? _selectedImage;
  ImagePicker _picker = ImagePicker();
  bool loading = false;
  Future getImage1() async {
    print("step11>>>>>");
    try {
      final _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      final profileimage = image;

      print("step11>>>>>$profileimage");
      _selectedImage = File(profileimage!.path.toString());
      setState(() {});
      print("step11>>>>>$_selectedImage");
    } catch (e) {
      print("error$e");
    }
  }

  Future uploadProfile(String email, String password, String username) async {
    try {
      setState(() {
        loading = true;
      });
      print("step1>>>");
      print("loading>>$loading");
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // print("SIGININ$userCredential");
      // final firestore = FirebaseFirestore.instance;
      // print("firestor>>$firestore");
      // User? user = FirebaseAuth.instance.currentUser;
      try {
        // await userCredential.user?.updateDisplayName(username.trim());
        // await userCredential.user?.reload(); // Refresh user data
        print("step2");
        final updatedUser = FirebaseAuth.instance.currentUser;
        print("Updated display name: ${updatedUser?.displayName}");
      } catch (e) {
        print("Error updating display name: $e");
      }
      final token = await FirebaseMessaging.instance.getToken();
      print("tokenn>>$token");
      // l.user?  .updateDisplayName(username.trim());
      // await userCredential.user?.reload();
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef = FirebaseStorage.instance.ref().child(
        'foodprofile/$imageName.jpg',
      );
      print("storagee ref>>$storageRef");
      var uploadTask = storageRef.putFile(_selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("doewnloadurl>>$downloadUrl");

      print("loading>>$loading");
      final docRef = firestore.collection("fooduser").doc();
      await docRef.set({
        "username": username,
        "fcmtoken": token,
        "Image": downloadUrl.toString(),
        "pincode": pincode.text,
      });

      final docid = docRef.id;
      dk = docid;
      final ak = foodOrder(pincode: pincode.text, docid: docid);
      print("akk>>${ak.docid}");
      print("Document ID: $docid");
      loading = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => sl(docId: docid)),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {});
    } catch (e) {
      loading = false;
      print("error>>>>$e");
      final snackdemo = SnackBar(
        content: Text(' error ${e}'),
        backgroundColor: Colors.green,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackdemo);
    }
  }

  final firestore = FirebaseFirestore.instance;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController pincode = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: Container(
        //
        child: Container(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: CircleAvatar(
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : null,
                            radius: 50,
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          right: -3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                getImage1();
                              },
                              icon: Icon(Icons.camera_alt_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a  username';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: Text('username'),
                            ),
                          ),
                          TextFormField(
                            controller: pincode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter a pincode';
                              }
                              return null;
                            },
                            decoration: InputDecoration(label: Text('pincode')),
                          ),
                          // TextFormField(
                          //   controller: email,
                          //   validator: (value) {
                          //     if (value!.isEmpty ||
                          //         !RegExp(
                          //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          //         ).hasMatch(value!)) {
                          //       return 'Enter a valid email!';
                          //     }
                          //   },
                          //   decoration: InputDecoration(label: Text('email')),
                          // ),
                          // TextFormField(
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'Enter a  password contain 6 digit!';
                          //     }
                          //     return null;
                          //   },
                          //   controller: password,
                          //   decoration: InputDecoration(
                          //     label: Text('password'),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 194, 91, 59),
                            Colors.redAccent,
                          ],
                        ),
                      ),
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await uploadProfile(
                              email.text,
                              password.text,
                              username.text,
                            );

                            if (loading == false) {
                              // value.loading = true;
                            } else {
                              print("not acceptable");
                            }
                            setState(() {});
                          }
                        },
                        //  value.uploadfirebase1(
                        //       email.text, password.text, username.text);
                        //   if (value.loading == false) {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => MyHomePage()));
                        //   } else {
                        //     print("not acceptable");
                        //   }
                        // },
                        child: Text(
                          "sign in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Divider(thickness: 2),
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Divider(thickness: 2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.red],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Signup()));
                          // value.signin(
                          //   email.text,
                          //   password.text,
                          // );
                          // if (value.loading1 == false) {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => MyHomePage()));
                          // } else {
                          //   print("not acceptable");
                          // }
                        },
                        child: Text(
                          "log in",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (loading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
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
