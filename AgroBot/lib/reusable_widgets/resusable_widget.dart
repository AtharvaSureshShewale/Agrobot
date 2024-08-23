import 'package:flutter/material.dart';

Image logoWidget(String imageName,double h,double w){
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: w,
    height: h,
    color: Colors.white,
  );
}

TextField reusableTextField(String text,IconData icon, bool isPasswordType, TextEditingController controller){
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color:Colors.white70
      ),
    labelText: text,
    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    fillColor: Colors.white.withOpacity(0.3),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(width: 0,style:BorderStyle.none),
    ),
    ),
    keyboardType: isPasswordType?TextInputType.visiblePassword:TextInputType.emailAddress,
  );
}

ButtonStyle buttonSecondary(Color color1, bool includeBorder,) {
  return ElevatedButton.styleFrom(
    minimumSize: const Size(300, 60),
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      side: includeBorder ? const BorderSide(color: Color(0xFF02AA6D), width: 2) : BorderSide.none,
    ),
    backgroundColor: color1,
  );
}

Container signinSignupScreenButton(BuildContext context,bool isLogin,Function onTap){

  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
      style: buttonSecondary(Colors.white,false),
      onPressed: (){
        onTap();
      },
      child: Text(isLogin?'Login':'SignUp',style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16),),
    ),
  );

}

