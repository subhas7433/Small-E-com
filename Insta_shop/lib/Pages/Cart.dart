


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Model/ProductsDetails.dart';
import '../Model/StaticVar.dart';
import '../main.dart';
import 'ProductDetailsPage.dart';

class CartPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _chatPage();
  }

}

class _chatPage extends State<CartPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:   SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20,left: 10,right: 10),
            color: StaticVar.backGray.withOpacity(.3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: const Text(
                    'Cart',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                  ),
                ),


                Expanded(
                    child: products()
                )




              ],
            ),
          ),
        ),


        // This trailing comma makes auto-formatting nicer for build methods.
      );
  }

  Widget products() {


    List<ProductsDetails> pList=[];
    print("Product item list = ${StaticVar.cartProductIDList}");
    for(var p in StaticVar.productDetailsList)
    {

      if(StaticVar.cartProductIDList.contains(p.id.toString()))
        {
          pList.add(p);
        }

    }




    if(pList.length>0) {
      return ListView.builder(
        itemCount: pList.length,
        itemBuilder: (BuildContext context, int index) {
          return   Container(
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
                    child: InkWell(
                      enableFeedback: false,
                      onTap: (){
                        openProductDetails(pList[index]);
                      },
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
                  ),
                  InkWell(
                    onTap: (){
                      deleteFromCart(pList[index].id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red.withOpacity(.2)
                      ),
                      child: Icon(Icons.delete,color: Colors.red,size: 20,),
                    ),
                  )

                ],
              )
          );

        },

      );
    }else{
      return Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
           children: [
            Icon(Icons.remove_shopping_cart,color: Colors.black,size: 100,),
            SizedBox(
              height: 20,
            ),
            Text(StaticVar.noCartItem),

        ],
      )
        ),
      );
    }

  }


  @override
  void initState() {

  }

  void openProductDetails(ProductsDetails p) {

    Navigator.push(context,MaterialPageRoute(builder: (context) => ProductDetailsPage(product: p)));

  }

 void deleteFromCart( int id) async{

    await showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white,

            title: const Text("Remove"),
            content: const Text("Do you want to remove this item from Cart ?"),
            actions: [

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                },
                child: const Text("No",style: TextStyle(color: Colors.black),),

              ),
              TextButton(
                onPressed: () {
                  removeFromCart(id);
                  Navigator.of(context).pop();

                },
                child: const Text("Yes",style: TextStyle(color: Colors.black),),

              ),
            ],

          );
        });

  }
  void removeFromCart(int id) async {

    if(StaticVar.cartProductIDList.contains(id.toString()))
    {
      StaticVar.cartProductIDList.remove(id.toString());
    }

    StaticVar.sp.setStringList(StaticVar.spProductsInCart, StaticVar.cartProductIDList);

    

    setState(() {

    });

    StaticVar.showToast("Successfully removed from Cart");
  }


}