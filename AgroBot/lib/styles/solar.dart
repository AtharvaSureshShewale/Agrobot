// import 'package:agrobot/Screens/solar_screen.dart';
import 'package:agrobot/styles/button1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Solar extends StatelessWidget{

  const Solar({super.key});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(120,120)),
      onPressed: (){
        // Navigator.push(context,MaterialPageRoute(builder: (context)=>const SolarScreen()));
      }, 
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.solarPanel,size: 40,),
            Text('Solar',style: TextStyle(fontSize: 20,fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }

}