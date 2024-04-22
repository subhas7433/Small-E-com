

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_shop/main.dart';

import '../Model/StaticVar.dart';

class LoginPage extends StatefulWidget{


  const LoginPage({super.key});




  @override
  State<StatefulWidget> createState() => _LoginPage();

}

class _LoginPage extends State<LoginPage>{


  bool shouldExit=false;

  bool shouldShowPass=false;


  _LoginPage();

  var emailControler = new TextEditingController();
  var passControler = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
      
            body:Container(
              height: double.infinity,
             color: StaticVar.backGray,
             child: SingleChildScrollView(
              child: Container(
                color: StaticVar.backGray,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        padding: const EdgeInsets.only(top: 40,left: 20),
                        color: Colors.black,
                        width: double.infinity,
                        height: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
      
                              ),
      
                              child: const Icon(Icons.shopping_cart,size: 50,color: Colors.white,),
      
      
                            ),
                            const Text(StaticVar.appName,style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w600,),),
                            const Text(StaticVar.appTagLine,style: TextStyle(fontSize: 12
                                ,color: Colors.white,fontWeight: FontWeight.w300 ),),
                          ],
                        ),
                      ),
                    ),
                    Container(
      
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(StaticVar.login,style: TextStyle(fontSize: 32,color: Colors.black,fontWeight: FontWeight.w600,),),
                          const Text(StaticVar.loginBottom,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w300,),),
                          Container(
                              margin: const EdgeInsets.only(top: 25),
                              child: const Text(StaticVar.emailID,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w300,),)),
                          Container(
                            margin: const EdgeInsets.only(top: 10,bottom: 10),
                            child: TextField(
                              maxLines: 1,
                              controller: emailControler,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      
                                  hintText: StaticVar.emailIDHint,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w300
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18)
                                  )
                              ),
                            ),
                          ),
                          const Text(StaticVar.password,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w300,),),
                          Container(
                            margin: const EdgeInsets.only(top: 10,bottom: 10),
                            child: TextField(
                              obscureText: !shouldShowPass,
                              maxLines: 1,
                              controller: passControler,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      
                                  hintText: StaticVar.loginPasswordHint,
                                  hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18)
                                  )
                              ),
                            ),
                          ),
      
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
      
                                Transform.scale(
                                  scale:.8,
                                  child: Checkbox(
                                    value: shouldShowPass,
                                    side: BorderSide(color: Colors.grey.shade500),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (bool? changed)
                                    {
      
                                      if (changed != null) {
                                        setState(() {
                                          shouldShowPass = changed;
                                        });
                                      }
      
                                    },),
                                ),
                                InkWell(
                                  enableFeedback: false,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: ()
                                  {
                                    setState(() {
                                      shouldShowPass= !shouldShowPass;
                                    });
      
                                  },
                                  child:Text(StaticVar.showPass,style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                                )
      
      
                              ]
                          ),
                          TextButton(
      
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(const Size (double.infinity,50)),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.black)
                            ),
                            onPressed:(){
                              _startLoginProcess();
      
                            },
                            child: const Text(
                              StaticVar.login, style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600),
                            ),
      
      
                          ),
                          const SizedBox(
                            height: 10,
                          ),
      
      
      
                        ],
                      ),
                    ),
      
      
                  ],
                ),
              ),
            )
            )
      
      
      
      
        ),
    );
  }







  @override
  void initState() {

  }
  void _startLoginProcess() async
  {

    String emailTxt=emailControler.value.text.trim();
    String passTxt=passControler.value.text;

    String? storedEmail= await StaticVar.storage.read(key: StaticVar.storageUserEmail);
    String? storedPass= await StaticVar.storage.read(key: StaticVar.storageUserPass);

    if(emailTxt.isEmpty)
      {
        ShowSnackBar("Please enter Email id", context);
      }
    else if(!emailTxt.contains("@") || !emailTxt.contains("."))
        {
          ShowSnackBar("Please enter a valid email id", context);
        }
    else if(passTxt.length<6)
      {
        ShowSnackBar("Enter password longer then 5 Characters", context);
      }
    else if(storedEmail !=  emailTxt || storedPass != passTxt)
    {
      ShowSnackBar("Invalid Email or Password", context);
    }
    else
    {
      StaticVar.sp.setBool(StaticVar.SpLogin,true);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "")));

      StaticVar.showToast("Login Successful");

    }



  }

  void ShowSnackBar(String s,BuildContext context) {
    final snackBar= SnackBar(content: Text(s,style: const TextStyle(color: Colors.white),),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        backgroundColor: Colors.black);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}





class WaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path=Path();


    path.lineTo(0, size.height / 1.55);
    var firstControlPoint = Offset(size.width / 6, size.height - 60);
    var firstEndPoint = Offset(size.width / 3, size.height / 1.50 - 10);
    var secondControlPoint =
    Offset(size.width / 2.1 , size.height / 2);
    var secondEndPoint = Offset(size.width - (size.width / 2.8), (size.height - (size.height/3)));

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.quadraticBezierTo(size.width - (size.width/8) ,size.height - 20,
        size.width, size.height - (size.height/3.5));

    // Continue with the rest of your path definition
    // path.quadraticBezierTo(size.width / 6, size.height - 100, size.width / 2, size.height - 40);
    // path.quadraticBezierTo(size.width - (size.width / 4), size.height, size.width, size.height - 100);

    // path.quadraticBezierTo(size.width / 6, size.height - 100, size.width / 2, size.height - 40);
    //
    // path.quadraticBezierTo(size.width - (size.width / 4), size.height, size.width, size.height-100);

    path.lineTo(size.width, 0.0);

    path.close();

    return path;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper)  => false;

}