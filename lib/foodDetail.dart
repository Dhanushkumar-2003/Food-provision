import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodprovision/bottomnav.dart';
import 'package:foodprovision/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class FoodDetail extends StatefulWidget {
  final String docid;
  const FoodDetail({super.key, required this.docid});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> with TickerProviderStateMixin {
  List<File> selectedImages = [];
  List<XFile> xfilePick = [];
  final picker = ImagePicker();

  final TextEditingController foodname = TextEditingController();
  final TextEditingController kg = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController location = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  Future<void> getImages() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 85);
    xfilePick = pickedFile;

    if (selectedImages.length + xfilePick.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can select only up to 5 images')),
      );
      return;
    }

    if (xfilePick.isNotEmpty) {
      for (var file in xfilePick) {
        selectedImages.add(File(file.path));
      }
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  bool loading = false;

  Future<void> createPost(String title, String kg, String pincode) async {
    try {
      loading = true;
      setState(() {});
      // final uid = FirebaseAuth.instance.currentUser;
      if (widget.docid != "") {
        List<String> downloadUrls = [];

        for (var image in selectedImages) {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference ref = FirebaseStorage.instance.ref().child(
            'uploads/$fileName.jpg',
          );
          UploadTask uploadTask = ref.putFile(File(image.path));
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
        }

        await FirebaseFirestore.instance.collection('posts').doc().set({
          'title': title,
          'location': location.text,
          'kg': kg,
          'pincode': pincode,
          'image': downloadUrls,
          'status': 'pending',
          'response': null,
          "customerlocation": null,
          'userid': widget.docid,
          "customeruid": null,
          "adminconfirmation": null,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post uploaded successfully!")),
        );

        foodname.clear();
        // kg.clear();
        // pincode.clear();
        selectedImages.clear();

        // loading = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sl(docId: widget.docid)),
        );
        // setState(() {});
      }
    } catch (e) {
      print("Error uploading post: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    return Scaffold(
      body: CustomPaint(
        painter: FoodPainter(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: FadeTransition(
              opacity: _fadeController,
              child: SlideTransition(
                position: slideAnimation,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ClipPath(
                            clipper: WaveClipper(),
                            child: Container(
                              height: 120,
                              color: Colors.orange.shade700,
                              alignment: Alignment.center,
                              child: const Text(
                                "Tell the food detail 🍽️",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: foodname,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }

                              return null; // valid
                            },
                            decoration: InputDecoration(
                              labelText: 'Food Name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: pincode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a number';
                              }
                              final number = num.tryParse(value);
                              if (number == null) {
                                return 'Enter a valid number';
                              }
                              return null; // valid
                            },
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: kg,
                            decoration: InputDecoration(
                              labelText: 'How many kg?',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            minLines: 3,
                            //  minLines: 1,//Normal textInputField will be displayed
                            maxLines: 5,
                            controller: location,
                            decoration: InputDecoration(
                              helperMaxLines: 2,
                              labelText: 'location',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: getImages,
                            icon: const Icon(color: Colors.white, Icons.image),
                            label: const Text(
                              "Select Images",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          selectedImages.isEmpty
                              ? const Text("No images selected")
                              : GridView.builder(
                                  itemCount: selectedImages.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                      ),
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: kIsWeb
                                          ? Image.network(
                                              selectedImages[index].path,
                                            )
                                          : Image.file(
                                              selectedImages[index],
                                              fit: BoxFit.contain,
                                            ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // ignore: unrelated_type_equality_checks
                                if (selectedImages.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('enter atleast one image'),
                                    ),
                                  );
                                } else {
                                  createPost(
                                    foodname.text,
                                    kg.text,
                                    pincode.text,
                                  );
                                }
                              }
                            },
                            child: const Text("Upload"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 12,
                              ),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (loading)
                      Center(
                        child: SpinKitPouringHourGlassRefined(
                          // waveColor: Colors.red,
                          color: Colors.deepOrange,
                          size: 50.0,
                          controller: AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 1200),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 20);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FoodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 179, 132, 63).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.35,
      size.width * 0.5,
      size.height * 0.45,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.55,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
