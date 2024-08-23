import 'package:agrobot/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAmv79_QQnO4sVo-8LSlU1NDE64AEPvoOE', 
      appId: '1:989810940058:android:4db1790d50cca0d5ad2723', 
      messagingSenderId: '989810940058', 
      projectId: 'agrobot-project',
      storageBucket: 'gs://agrobot-project.appspot.com'
      )
  );
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
}

  Color myColor=const Color(0xFF02AA6D);
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF02AA6D)),
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}
