import 'package:flutter/material.dart';
import 'package:foodprovision/foodorder.dart';
import 'package:foodprovision/home.dart';
import 'package:foodprovision/orderlist.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key});
//   final List<Widget> screens = [
//     Home(),
//     // Home(username: '', pincode:'')
//     foodOrder(pincode: ''),
//     Orderlist(),
//   ];
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text('My App'),
//       // ),
//       body: widget.screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//             print('currentndex>$_currentIndex');
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             backgroundColor: Colors.blue,
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.public), label: 'pr'),
//         ],
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Home Screen'));
//   }
// }

class sl extends StatefulWidget {
  final String docId;
  final int initialIndex;

  sl({super.key, required this.docId, this.initialIndex = 0});

  @override
  State<sl> createState() => _slState();
}

class _slState extends State<sl> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  @override
  void initState() {
    _selectedIndex;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Home(docid: widget.docId), // Your custom widget
      foodOrder(pincode: '', docid: widget.docId),
      Orderlist(userid: ''),
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 0,
          bottom:
              MediaQuery.of(context).padding.bottom +
              8, // Adaptive bottom margin
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.3)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.blue[300]!,
              hoverColor: Colors.blue!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.orange!,
              color: Colors.black,
              tabs: const [
                GButton(
                  textColor: Colors.white,
                  icon: Icons.home_outlined,
                  iconColor: Colors.red,
                  iconActiveColor: Colors.white,
                  text: 'Home',
                ),
                GButton(
                  textColor: Colors.white,
                  iconColor: Colors.red,
                  iconActiveColor: Colors.white,
                  icon: Icons.menu_book_rounded,
                  text: 'dish',
                ),

                GButton(
                  textColor: Colors.white,
                  iconColor: Colors.red,
                  iconActiveColor: Colors.white,
                  icon: Icons.person_2_outlined,
                  text: 'My order',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
