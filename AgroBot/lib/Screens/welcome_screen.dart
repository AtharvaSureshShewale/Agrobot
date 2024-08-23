import 'package:agrobot/Screens/login_screen.dart';
import 'package:agrobot/Screens/signup_screen.dart';
import 'package:agrobot/styles/button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget{

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
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
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Image.asset('assets/images/HelloScreen.png')
            ),
            const Text('Hello',style:TextStyle(fontSize:40,fontFamily: 'UbuntuCondensed',fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 300,
              child: Text('Welcome to AgroBot, let us guide you through the farming world',style: TextStyle(fontSize: 16),textAlign: TextAlign.center,)),
            const SizedBox(height:50),
            ElevatedButton(
              style:buttonSecondary(const Color(0xFF02AA6D),false),
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> const LoginScreen()));
              }, 
              child: const Text('Login',style: TextStyle(fontSize: 20,color: Colors.white),)
            ),
            const SizedBox(height:10),
            ElevatedButton(
              style:buttonSecondary(Colors.white,true),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
              }, 
              child: const Text('SignUp',style: TextStyle(fontSize: 20,color: Colors.black),)
            ),
            const SizedBox(height:50),
            const Text('Join Us'),
            const SizedBox(height:10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.telegram,size: 40,color: Colors.blue,),
                SizedBox(width:15),                
                FaIcon(FontAwesomeIcons.instagram,size: 40,color: Colors.black,),
                SizedBox(width:15),
                FaIcon(FontAwesomeIcons.twitter,size: 40,color: Colors.blue,),
                SizedBox(width:15),
                FaIcon(FontAwesomeIcons.google,size: 40,color: Colors.black,),
              ],
            ),
          ],
        )
      ),
    );
  }
}