import 'package:bookbuddy/classes/Language.dart';
import 'package:bookbuddy/pages/HomeScreen.dart';
import 'package:bookbuddy/themes/theme_constants.dart';
import 'package:bookbuddy/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();


  // Check if user data is available
  String? name = prefs.getString('name');
  String? email = prefs.getString('email');
  String? language = prefs.getString('language');

  runApp(MyApp(
    name: name,
    email: email,
    language: language,
  ));
}

ThemeManager _themeManager = ThemeManager();
class MyApp extends StatefulWidget {
  final String? name;
  final String? email;
  final String? language;

  const MyApp({Key? key, this.name, this.email, this.language}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListner);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeManager.addListener(themeListner);
  }

  themeListner(){
    if(mounted){
      setState(() {
        
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.name != null && widget.email != null && widget.language != null) {
      // User data is available, navigate to HomeScreen
      return MaterialApp(
        localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'), // English
    Locale('ea'),
     Locale('hi')
  ],

  locale: Locale('hi', ''),
        theme: lighttheme,
        darkTheme: darktheme,
        themeMode: _themeManager.themeMode,
        debugShowCheckedModeBanner: false,
        home: HomeScreen(name: widget.name!, email: widget.email!, language: widget.language!),
      );
    } else {
      // User data is not available, show SignupPage
      return MaterialApp(
        theme: lighttheme,
        darkTheme: darktheme,
        themeMode: _themeManager.themeMode,
        debugShowCheckedModeBanner: false,
        home: SignupPage(),
      );
    }
  }
}

// ... (rest of the code remains the same)

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Change theme'),
        actions: [Switch(value: _themeManager.themeMode ==ThemeMode.dark, onChanged: (newValue){
           _themeManager.togglTheme(newValue);
        })],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            Center(
              child: Row(children:[Image(image: AssetImage('images/bookicon.gif')),
              RichText(
                text: TextSpan(
                  text: "Create Account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                  color: _themeManager.themeMode ==ThemeMode.dark ? Colors.white : Colors.black,),
                ),
              ),],),
            ),
           
            SizedBox(height: 16.0),
            _buildNameField(),
            SizedBox(height: 16.0),
            _buildEmailField(),
            SizedBox(height: 16.0),
            _buildPasswordField(),
            SizedBox(height: 16.0),
            _buildLanguageDropdown(),
            SizedBox(height: 24.0),
            _buildSignupButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
    );
  }
  

  Widget _buildLanguageDropdown() {
  return Row(
    children: [
      Icon(Icons.language),
      SizedBox(width: 8),
      DropdownButton<String>(
        value: selectedLanguage,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedLanguage = newValue;
            });
          }
        },
        items: Language.languageList().map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem<String>(
            value: e.name,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(e.flag),
                Text(e.name),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}


  Widget _buildSignupButton(BuildContext context) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    onEnter: (_) {Null;}, // Set onEnter to null to disable hover effect
    onExit: (_) {Null;}, // Set onExit to null to disable hover effect
    child: ElevatedButton(
      onPressed: () async {
        var name = _nameController.text.toString();
        var email = _emailController.text.toString();
        var language = selectedLanguage; // Get selected language

        var prefs = await SharedPreferences.getInstance();
        prefs.setString("name", name);
        prefs.setString("email", email);
        prefs.setString("language", language); // Save language preference

        if (_validateInputs(context)) {
          // Use Navigator.pushReplacement to replace SignupPage with HomeScreen
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => HomeScreen(
                name: name,
                email: email,
                language: language,
              ),
              transitionsBuilder: (_, animation, __, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                var curve = Curves.easeInOutQuart;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 900),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        onPrimary: Colors.black, // Add black border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Reduce the width
        children: [
          Text('Register Now', style: TextStyle(fontSize: 20,color: _themeManager.themeMode ==ThemeMode.dark ? Colors.white : Colors.black,)),
          Icon(Icons.arrow_forward),
        ],
      ),
    ),
  );
}

  bool _validateInputs(BuildContext context) {
    // Basic email validation using regex
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter a valid email address'),
        ),
      );
      return false;
    }

    // Basic password validation (minimum 6 characters)
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return false;
    }

    return true;
  }
}
