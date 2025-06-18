import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ItemData extends ChangeNotifier {
  File? _selectedImage;
  File? get selectImage => _selectedImage;
  bool uploaded = false;
  bool _picke = false;
  bool get picke => _picke;
  String _filePath = "";
  String get filePath => _filePath;
  bool _loading = false;
  // bool _loading = false;
  bool get loading => _loading;
  bool _loading1 = false;
  bool get loading1 => _loading;
  File? _selectedImage1;
  File? _file;
  File? get file => _file;

  File? get selectImage1 => _selectedImage;
  String _downloadUrlAudio = "";
  String get downloadUrlAudio => _downloadUrlAudio;
  String _getlink = "";
  String get getlink => _getlink;
  bool get complete => _complete;
  bool _complete = false;
  bool _updateprofile = false;
  bool get updateprofile => _updateprofile;
  bool _indiacater = false;
  bool get indiacater => _indiacater;
  String _pincode = "";
  String get pincode => _pincode;

  Future uploadProfile(
    String email,
    String password,
    String username,
    String pincode,
  ) async {
    try {
      _pincode = pincode; // ✅ Store pincode in memory too
      notifyListeners();

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;

      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('foodprofile/$imageName.jpg');
      var uploadTask = storageRef.putFile(_selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();

      await firestore.collection("fooduser").doc(userCredential.user!.uid).set({
        "username": username,
        "Image": downloadUrl.toString(),
        "pincode": pincode,
      });

      _loading = false;
      notifyListeners();
    } catch (e) {
      print("error>>>>$e");
    }
  }
}
