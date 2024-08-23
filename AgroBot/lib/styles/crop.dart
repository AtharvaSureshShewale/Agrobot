import 'package:agrobot/Screens/crop_screen.dart';
import 'package:agrobot/styles/button1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Crop extends StatelessWidget{

  const Crop({super.key});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(110,120)),
      onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder:(context)=>const HomePage()));
      }, 
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.wheatAwn,size: 40,),
            Text('Crop Health',style: TextStyle(fontSize: 20,fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }

}