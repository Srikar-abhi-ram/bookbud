import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Books.dart';
import 'Profile.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String email;
  final String language;

  HomeScreen({
    required this.name,
    required this.email,
    required this.language,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  Future<void> _logout(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('email');
    prefs.remove('language');

    // Navigate to SignupPage and remove all previous routes from the stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(),
      ),
      (route) => false, // This will remove all routes from the stack
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: EdgeInsets.all(25.0),
          child: Books(booklist: []));
      case 1:
        return ProfilePage(
          name: widget.name,
          email: widget.email,
          language: widget.language,
        );
      default:
        return Container(); // Add your default page here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false,
  title: Padding(
    padding: EdgeInsets.only(left: 15.0, top: 20.0),
    child: Text(
      'Book buddy',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 198, 147, 19),
      ),
    ),
  ),
  actions: [
    Padding(
      padding: EdgeInsets.only(top: 15.0,right: 20.0),
      child: GestureDetector(
        child: Row(children: [Text('Logout' ,style: TextStyle(color: Color.fromARGB(255, 198, 147, 19),fontSize:15)),Image.asset('images/logout.gif')]),
        onTap: () => _logout(context),
      
      ),
    ),
  ],
),

      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemCount: 2, // Adjust the count based on the number of pages
        itemBuilder: (context, index) {
          return _buildPage(index);
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only( bottom:20.0,
        left: 20.0,
        right: 20.0),
        
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: Color.fromARGB(255, 198, 147, 19),
            selectedItemColor: Colors.white,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
