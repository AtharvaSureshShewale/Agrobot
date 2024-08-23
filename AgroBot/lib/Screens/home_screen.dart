import 'package:agrobot/Screens/device_list_screen.dart';
import 'package:agrobot/Screens/login_screen.dart';
import 'package:agrobot/Screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  final double h=200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAFFF2),
        title: const Text('AgroBot',style: TextStyle(color:Color(0xFF006D44),fontFamily: 'UbuntuCondensed',fontWeight: FontWeight.bold),),
        actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
              FirebaseAuth.instance.signOut().then((value) async {
              if (kDebugMode) {
                print("Signed Out");
              }
              var sharedPref= await SharedPreferences.getInstance();
              sharedPref.setBool(SplashScreenState.keyLogin,false);
              // ignore: use_build_context_synchronously
              Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
            }).onError((error, stackTrace) {
              if (kDebugMode) {
                print("Error ${error.toString()}");
              }
            });
              },
            ),
          ],
      ),
      body: const DeviceListScreen(),
    );
  }
}
