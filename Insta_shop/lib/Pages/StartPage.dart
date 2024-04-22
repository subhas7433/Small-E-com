


import 'package:flutter/material.dart';
import 'package:insta_shop/Pages/CreateACPage.dart';
import 'package:insta_shop/Pages/LoginPage.dart';
import 'package:insta_shop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/StaticVar.dart';

class StartPage extends StatefulWidget{
  const StartPage({super.key});

  @override
  _startPage createState() => _startPage();

}

class _startPage extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle
            ),
            child: const Icon(Icons.shopping_cart,size: 50,color: Colors.white,),
          ),

        ],
      ),

    );
  }


  @override
  void initState() {
    initializeSp();

  }

  Future<void> goToMain() async{
    // wait for a second
    await Future.delayed(const Duration(seconds: 1));

    //checking if user Loged in or not
    if(StaticVar.sp.getBool('login')==null || StaticVar.sp.getBool('login')==false) // when entering first time it will return null then true or false
        {
          StaticVar.sp.setBool('login', false);
      Navigator.push(context, MaterialPageRoute(builder:(context) =>
       const CreateACPage()
      ));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyHomePage(title: '',)));
    }
}
  initializeSp() async {
    StaticVar.sp=await SharedPreferences.getInstance() ;
    goToMain();
  }

}