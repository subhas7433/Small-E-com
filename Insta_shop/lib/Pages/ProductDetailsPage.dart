



import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:insta_shop/Model/ProductsDetails.dart';
import 'package:insta_shop/Model/StaticVar.dart';
import 'package:insta_shop/Pages/Cart.dart';
import 'package:insta_shop/main.dart';

class ProductDetailsPage extends StatefulWidget{
  ProductsDetails product;
  ProductDetailsPage(
  {
    required this.product
  }
  );
  @override
  State<StatefulWidget> createState() => _productDetails(product: product);

}

class _productDetails extends  State<ProductDetailsPage>{

  
  ProductsDetails product;
  _productDetails(
      {
        required this.product
      }
      );
  bool isInCart=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            color: StaticVar.backGray.withOpacity(.2),
            child: Column(
              children: [

                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 250,
                            width: 350,
                            padding: EdgeInsets.symmetric(vertical:20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow:[
                                BoxShadow(
                                  color: Colors.grey.shade300.withOpacity(0.3),
                                  spreadRadius: 10,
                                  blurRadius: 10
                              ) ],
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),

                            child: Image.network(
                              product.image,
                              // Optional parameters:
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Text('Failed to load image');
                              },
                              // Adjust the width and height as needed
                              width: 300,
                              height: 200,
                              fit: BoxFit.contain, // Adjust the box fit as needed
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      Text(product.title,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),
                        maxLines: 2,),
                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            Text("${product.rating['count'].toString()} Ratings ",
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                            RatingBar.builder(
                              initialRating: product.rating['rate'].toDouble(), // Set the initial rating
                              minRating: 1, // Set the minimum rating
                              direction: Axis.horizontal,
                              allowHalfRating: true, // Enable half rating
                              itemCount: 5, // Number of total stars
                              ignoreGestures: true,
                              itemSize: 12,
                              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),


                              onRatingUpdate: (double value) {  }, // Updates the rating as the user drags
                            ),
                            SizedBox(width: 2,),
                            Text("(${product.rating['rate'].toString()})",
                                style: TextStyle(fontSize: 11,)),

                          ],
                        ),

                        SizedBox(
                          height: 2,
                        ),
                        Text("\$ ${product.price}" ,
                          style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),
                          maxLines: 2,),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Description" ,
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(product.description ,
                              style: TextStyle(fontSize: 14,color: Colors.black)),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300.withOpacity(.4),
                                borderRadius:BorderRadius.circular(8)
                            )
                        )

                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    isInCart ? removeFromCart() : addToCart();

                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 5),
                    margin: EdgeInsets.symmetric(horizontal: 20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart,size: 20,color: Colors.white,),
                        SizedBox(
                          width: 20,
                        ),
                        Text( isInCart ? StaticVar.removeFromCart : StaticVar.addToCart,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: .5,
                        ),
                        borderRadius:BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300.withOpacity(0.3),
                              spreadRadius: 10,
                              blurRadius: 10
                          )]

                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  @override
  void initState() {
    isInCart=StaticVar.cartProductIDList.contains(product.id.toString());

  }


  Future<void> _navigateAndRefresh(BuildContext context) async {
    // Navigate to the next page
   bool result= await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage()),
    );

    if(result){
      refreshPage();
    }

  }
  void refreshPage(){
    setState(() {

    });
  }
  void addToCart() async {

    if(!StaticVar.cartProductIDList.contains(product.id.toString()))
    {
      StaticVar.cartProductIDList.add(product.id.toString());
    }

    StaticVar.sp.setStringList(StaticVar.spProductsInCart, StaticVar.cartProductIDList);
    StaticVar.showToast(StaticVar.addedToCart);
    isInCart=true;
    setState(() {

    });

  }
  void removeFromCart() async {

    if(StaticVar.cartProductIDList.contains(product.id.toString()))
      {
        StaticVar.cartProductIDList.remove(product.id.toString());
      }

    StaticVar.sp.setStringList(StaticVar.spProductsInCart, StaticVar.cartProductIDList);

    StaticVar.showToast(StaticVar.removeFromCart);
    isInCart=false;
    setState(() {

    });

  }
}