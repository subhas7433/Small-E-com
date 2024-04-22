
import 'dart:convert';
import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insta_shop/Model/ProductsDetails.dart';
import 'package:insta_shop/Pages/ProductDetailsPage.dart';
import 'package:insta_shop/Pages/StartPage.dart';
import 'package:http/http.dart' as http;

import 'Model/StaticVar.dart';
import 'Pages/Cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

       inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: StaticVar.textFieldBorderGray, // Background color
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              borderSide: BorderSide(color: Colors.black, width: 2.0), // Focused border color and width
            ),
            ),

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: StartPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
enum Options { option1, option2, option3,option4 }
class _MyHomePageState extends State<MyHomePage> {

  late List<Category> categories = [];
  Category? selectedCategory;

  Options? selectedOption=Options.option1;


  @override
  void initState() {
    categories = fetchCategories(); // Initialize categories
    if (categories.isNotEmpty) {
      selectedCategory = categories.first; // Select the first category initially
    }
    getCartIdList();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope (

      onWillPop:()  async {

        if(Platform.isAndroid)
        {
          StaticVar.exitAppDialog(context);
          return false;
        }else{
          return true;
        }

      },
      child: Scaffold(
      body:   SafeArea(
        child: Container(
              padding: EdgeInsets.only(top:10,left: 10,right: 10),
              color: StaticVar.backGray.withOpacity(.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        children: [
                          const Text(
                              'Products',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                              ),
                            ),
                          Expanded(child: SizedBox()),
                          Container(
                            height: 35,
                            width: 35,
                            child: Center(child: Icon(Icons.shopping_cart_outlined,size: 20,color: Colors.white,)),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                border: Border.all(
                                  color: Colors.grey.shade300.withOpacity(0.3),
                                  width: 1,
                                ),
                                borderRadius:BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300.withOpacity(0.3),
                                      spreadRadius: 10,
                                      blurRadius: 10
                                  )]
                            ),

                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
        
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: categories
                            .map((category) => InkWell(
                            enableFeedback: false,
                            onTap: () => setState(() {
                              selectedCategory = category;
                               products(category);
                            }),
                            child: Container(

                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              decoration: BoxDecoration(
                                color: selectedCategory == category ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300.withOpacity(0.3),
                                      spreadRadius: 3,
                                      blurRadius: 10
                                  )
                                ]
                              ),
                              child: Text(
                                category.name.toUpperCase(),
                                style: TextStyle(
                                  color: selectedCategory == category ? Colors.white : Colors.black,
                                ),
                              ),
                            ),

                          ))
                          .toList(),

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: FutureBuilder<List<ProductsDetails>>(
                        future: fetchData(),
                        builder: (BuildContext context, AsyncSnapshot<List<ProductsDetails>> snapshot)
                        {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Data is still being loaded
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            // An error occurred
                            return Center(
        
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.wifi_tethering_error,color: Colors.black,size: 100,),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(StaticVar.productError),
                                    TextButton(
                                        onPressed: ()
                                        {
                                          setState(() {

                                          });
        
                                        }, child: Text("Retry"))
                                  ],
                                )
                            );
                          } else {
                            // Data is loaded
        
                            return products(selectedCategory!);
                          }
        
                        },
        
        
                      )
                  )
        
        
        
        
                ],
              ),
            ),
      ),
      ),);
  }



  Future<List<ProductsDetails>> fetchData() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      final data = jsonDecode(response.body);
      StaticVar.productDetailsList=[];
      StaticVar.productDetailsList=List<ProductsDetails>.from(data.map((item) => ProductsDetails.fromJson(item)));
      return StaticVar.productDetailsList;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  void handleCatagoryChanges(Options? value)
  {
    setState(() {
      selectedOption=value;
    });
  }

  List<Category> fetchCategories() {

    return [
      Category(id: 1, name: 'All'),
      Category(id: 2, name: 'men\'s clothing'),
      Category(id: 3, name: 'jewelery'),
      Category(id: 4, name: 'electronics'),
      Category(id: 5, name: 'women\'s clothing'),
    ];
  }

 Widget products(Category category) {
   List<ProductsDetails> pList=[];
    if(selectedCategory == categories.first)
      {
        pList=StaticVar.productDetailsList;
      }
    else
        {
          for(var p in StaticVar.productDetailsList)
            {
              print(" p.category = ${p.category}  and category.name = ${category.name}");
              if(p.category.trim().toLowerCase() == category.name.trim().toLowerCase())
                {
                  pList.add(p);
                }

            }

        }
    print(" plist.length ${pList.length}");





    return ListView.builder(
      itemCount: pList.length,
      itemBuilder: (BuildContext context, int index) {
        return  InkWell(
          enableFeedback: false,
          onTap: (){
            openProductDetails(pList[index]);
          },
          child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              height: 135,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow:[
                  BoxShadow(
                      color: Colors.grey.shade300.withOpacity(0.3),
                      spreadRadius: 10,
                      blurRadius: 10
                  )
                ] ,
              ),
              child:Row(
                children: [
                  Container(

                    child: Image.network(pList[index].image,fit: BoxFit.fitHeight,
                      height: 80,width: 80,),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2,
                        ),
                        Flexible(
                            child: Text(pList[index].title,
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),
                          maxLines: 2,)),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: pList[index].rating['rate'].toDouble(), // Set the initial rating
                              minRating: 1, // Set the minimum rating
                              direction: Axis.horizontal,
                              allowHalfRating: true, // Enable half rating
                              itemCount: 5, // Number of total stars
                              ignoreGestures: true,
                              itemSize: 15,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),


                              onRatingUpdate: (double value) {  }, // Updates the rating as the user drags
                            ),
                            SizedBox(width: 5,),
                            Text("(${pList[index].rating['count'].toString()})")
                          ],
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text("\$ ${pList[index].price}" ,
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),
                          maxLines: 2,),

                      ],
                    ),
                  ),

                ],
              )
          ),
        );
      },

    );
  }

  Future<void> getCartIdList() async{
    StaticVar.cartProductIDList=await StaticVar.sp.getStringList(StaticVar.spProductsInCart)??[];
    print("cart product id list ${StaticVar.cartProductIDList}");

  }
  void openProductDetails(ProductsDetails p) {

    Navigator.push(context,MaterialPageRoute(builder: (context) => ProductDetailsPage(product: p)));

  }
}
class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});
}



