import 'package:flutter/material.dart';
import 'package:insmanager/screens/chat/liveChat.dart';
import 'package:insmanager/screens/login_screens/forgetpw_screen.dart';
import 'package:insmanager/screens/login_screens/registration_screen.dart';
import 'package:insmanager/screens/login_screens/signup.dart';
import 'package:insmanager/screens/mainfour/addvehicle_screen.dart';
import 'package:insmanager/screens/mainfour/makeaclaims.dart';
import 'package:insmanager/screens/mainfour/myclaims.dart';
import 'package:insmanager/screens/maininterface_screen.dart';
import 'package:insmanager/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insmanager/screens/userprofle_screen.dart';
import 'screens/mainfour/vehicles_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/landingpage': (BuildContext context) => App(),
        '/signup': (BuildContext context) => SignUpScreen(),
        '/mainpage': (BuildContext context) => MainInterface(),
        '/registrationpage': (BuildContext context) => RegistrationScreen(),
        '/forgetpwpage': (BuildContext context) => ForgetPWScreen(),
        '/userprofilepage': (BuildContext context) => UserProfile(),
        '/vehicle': (BuildContext context) => Vehicle(),
        '/makeclaims': (BuildContext context) => MakeClaim(),
        '/claims': (BuildContext context) => Claims(),
        '/addvehicle': (BuildContext context) => AddVehicle(),
        '/phoneverification': (BuildContext context) => AddVehicle(),
        '/liveChat': (BuildContext context) => Chat(),
      },
      // home:RegistrationScreen(),
      // home:MakeClaim(),
    );
  }
}
