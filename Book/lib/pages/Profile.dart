import 'package:bookbuddy/pages/HomeScreen.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String language;

  ProfilePage({
    required this.name,
    required this.email,
    required this.language,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _selectedLanguage;
  int _selectedIndex = 1; // Index 1 represents the Profile page

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'profilePicture',
              child: CircleAvatar(
                radius: 80.0,
                child: Text(widget.name[0], style: TextStyle(fontSize: 40.0)),
              ),
            ),
            SizedBox(height: 16.0),
            FadeInProfileDetail(
              child: Text(
                ' ${widget.name}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FadeInProfileDetail(
              child: Text(
                ' ${widget.email}',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            SizedBox(height: 16.0),
            _buildLanguageDropdown(),
          ],
        ),
      ),
      );
  }

  Widget _buildLanguageDropdown() {
    return FadeInProfileDetail(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Preferred Language: ',
            style: TextStyle(fontSize: 20.0),
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedLanguage = newValue;
                });
              }
            },
            items: <String>['English', 'Spanish', 'Other']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Navigate to Home page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              name: widget.name,
              email: widget.email,
              language: widget.language,
            ),
          ),
        );
      }
    });
  }
}

class FadeInProfileDetail extends StatefulWidget {
  final Widget child;

  const FadeInProfileDetail({Key? key, required this.child}) : super(key: key);

  @override
  _FadeInProfileDetailState createState() => _FadeInProfileDetailState();
}

class _FadeInProfileDetailState extends State<FadeInProfileDetail> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
