import 'dart:async';
import 'package:agrobot/Screens/device_list_screen.dart';
import 'package:agrobot/Screens/login_screen.dart';
import 'package:agrobot/Screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  static const String keyLogin="Login";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    whereToGo();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color:const Color(0xFFDAFFF2),
          child: Image.asset('assets/images/LogoName.png'),
        ),
      ),
    );
  }


void whereToGo() async{

var sharedPref= await SharedPreferences.getInstance();

var isLoggedIn=sharedPref.getBool(keyLogin);

Timer(const Duration(seconds: 2),(){
  if(isLoggedIn!=null){
    if(isLoggedIn){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const DeviceListScreen()));
       }
    else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
      }
    } else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const SignupScreen()));
    }  
    }
  );
}

}