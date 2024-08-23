import 'package:agrobot/Screens/device_list_screen.dart';
import 'package:agrobot/Screens/splash_screen.dart';
import 'package:agrobot/reusable_widgets/resusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{

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
final TextEditingController _usernameTextController=TextEditingController();
final TextEditingController _emailTextController=TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Sign Up",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
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
                    reusableTextField("Enter Username", Icons.person_outline, false, _usernameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email", Icons.person_outline, false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),                    
                    reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    signinSignupScreenButton(context, false, (){
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailTextController.text, 
                        password: _passwordTextController.text
                      ).then((value) async {
                      if (kDebugMode) {
                        print("Created New Account");
                      }
                      var sharedPref= await SharedPreferences.getInstance();
                          
                          sharedPref.setBool(SplashScreenState.keyLogin,true);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const DeviceListScreen()));
                      }).onError((error, stackTrace) {
                        if (kDebugMode) {
                          print("Error ${error.toString()}");
                        }
                      });

                     
                    }),
                  ],
                ),
              ),
            ),
        ),
      );
  }

}