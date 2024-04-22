
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_shop/Model/ProductsDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticVar {
  static const Color colorPrimary=Color(0xFF0009FF);
  static const Color blue=Color(0xFF3B52ED);
  static const Color backGray=Color(0xFFF3F3F3);
  static const Color textFieldBorderGray=Color(0xB2E1E1E1);




  //texts

  static const String appName='Insta Shop';
  static const String appTagLine='Explore the world of Shopping';
  static const String addToCart='Add to Cart';
  static const String removeFromCart='Remove from Cart';
  static const String removedFromCart='Successfully Removed from Cart';
  static const String addedToCart='Successfully added to Cart';
  static const String productError='Error occurred while loading Products';

  //Create account screen
  static const String hello='Hello';
  static const String helloBottom='Create an account';
  static const String emailID='Email ID';
  static const String emailIDHint='example@gmail.com';

  static const String password='Password';
  static const String passwordHint='Enter a Strong Password';
  static const String rePassword='Confirm Password';
  static const String rePasswordHint='Re-enter the Password';
  static const String showPass='Show Password';
  static const String signIn='SIGN IN';
  static const String signWithGoogle='SIGN WITH GOOGLE';
  static const String asGuest='CONTINUE AS GUEST';
  static const String alreadyHaveAC='Already have an account ? ';
  static const String login='Login';
  static const String createAC='Create Account';

  //login screen

  static const String loginBottom='Login to your account';
  static const String loginPasswordHint='Enter your Password';

  static const String noCartItem='No item in Cart';


  static final storage = new FlutterSecureStorage();
  static late SharedPreferences sp;

  static  void showToast(String text)
  {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM, // You can change the position (TOP, CENTER, BOTTOM)
      timeInSecForIosWeb: 3, // This controls the duration the toast is displayed
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }


  static late List<ProductsDetails> productDetailsList;
  static late List<String> cartProductIDList;



  //text keys
  static const String SpLogin='login';
  static const String storageUserEmail='email';
  static const String storageUserPass='pass';
  static const String spProductsInCart='ProductsInCart';



  static bool shouldExit=false;

static void exitAppDialog(var context) async{

     await showDialog(context: context,
     builder: (BuildContext context){
       return AlertDialog(
         backgroundColor: Colors.white,

         title: const Text("Exit"),
         content: const Text("Do you want to exit the application ?"),
         actions: [

           TextButton(
             onPressed: () {
               Navigator.of(context).pop();

             },
             child: const Text("No",style: TextStyle(color: Colors.black),),

           ),
           TextButton(
             onPressed: () {
               Navigator.of(context).pop();
               shouldExit=true;
             },
             child: const Text("Yes",style: TextStyle(color: Colors.black),),

           ),
         ],

       );
     }).
     then((value)
     {
       if( shouldExit)
       {
         SystemNavigator.pop();
       }
     }
     );

 }






}