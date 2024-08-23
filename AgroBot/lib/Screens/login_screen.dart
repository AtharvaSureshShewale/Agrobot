import 'package:agrobot/Screens/device_list_screen.dart';
import 'package:agrobot/Screens/signup_screen.dart';
import 'package:agrobot/Screens/splash_screen.dart';
import 'package:agrobot/reusable_widgets/resusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
  }
  
  final TextEditingController _passwordTextController=TextEditingController();
  final TextEditingController _emailTextController=TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8711c1),Color(0xFF2472fc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            )
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20,MediaQuery.of(context).size.height*0.1,20,0),
                child: Column(
                  children: <Widget>[
                    logoWidget('assets/images/Without_BG.png',300,350),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Email", Icons.person_outline, false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    signinSignupScreenButton(context, true, (){
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailTextController.text, 
                        password: _passwordTextController.text).then((value) async {
                          if (kDebugMode) {
                            print("Login Successfully");
                          }
                          var sharedPref= await SharedPreferences.getInstance();
                          
                          sharedPref.setBool(SplashScreenState.keyLogin,true);
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const DeviceListScreen()));

                        });
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    signupOptions(),
                  ],
                ),
              ),
            ),
        ),
      );
  }

  Row signupOptions(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      const Text("Don't have account? ",style: TextStyle(color: Colors.white70),),
      GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=> const SignupScreen()));
        },
        child: const Text(
          'Sign Up',
          style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      )
      ],
    );
  }
}