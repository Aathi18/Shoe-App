import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bottomcartsheet extends StatelessWidget {
  const Bottomcartsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 600,
        padding: EdgeInsets.only(top: 20),
        color: Color(0xFFCEDDEE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 500,
              child: Column(
                children: [
                  for(int i=1;i<3;i++)
                  Container(
                    margin: EdgeInsets.symmetric(vertical:10,horizontal: 15 ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 140,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F9FD),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color:Color(0xFF475269).withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                      ],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, "itemPage");
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10,right: 60),
                                height: 90,
                                width: 100,
                                decoration: BoxDecoration(
                                      color: Color(0xFF475269),
                                  borderRadius: BorderRadius.circular(10),
      
                                ),
                              ),
                              Image.asset(
                                "images/$i.png",
                                height: 130,
                                width: 130,
                                fit: BoxFit.contain,
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nike Shoe",
                              style: TextStyle(
                                color: Color(0xFF475269),
                                fontWeight: FontWeight.w500,
                                fontSize: 23,

                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F9FD),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow:[ BoxShadow(
                                      color: Color(0xFF475269).withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                    ],
                                  ),
                                  child: Icon(CupertinoIcons.minus,
                                  size:18 ,),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("02",style:
                                    TextStyle(
                                      color: Color(0xFF475269),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF5F9FD),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow:[ BoxShadow(
                                      color: Color(0xFF475269).withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    ),
                                    ],
                                  ),
                                  child: Icon(CupertinoIcons.add,
                                    size:18 ,),
                                )
                              ],
                            )
                          ],
                        ),),
                        Spacer(),
                        Padding(padding: EdgeInsets.symmetric(vertical:25 ),
                        child:Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [ BoxShadow(
                                  color: Color(0xFF475269),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                            ],
                              ),
                              child:Icon(Icons.delete,
                              color: Colors.red,
                                size: 20,
                              ) ,

                            ),
                            Spacer(),
                            Text("\$50",
                            style: TextStyle(
                              color: Color(0xFF475269),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                            )
                          ],
                        ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F9FD),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(
                        color: Color(0xFF475269).withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )]
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Free",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475269),
                            ),),
                            Text("\$20",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475269),
                            ),)
                          ],
                        ),
                        Divider(height: 20,thickness: 0.5,
                            color: Color(0xFF475269),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sub-Total",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475269),
                            ),),
                            Text("\$100",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475269),
                            ),)
                          ],
                        ),
                        Divider(height: 20,thickness: 0.3,
                          color: Color(0xFF475269),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discount",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475269),
                            ),),
                            Text("-\$10",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),)
                          ],
                        ),
                      ],
                    ),
                  )
                ],

              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFF5F9FD),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF475269).withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Total",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF475269)
                      ),),
                      SizedBox(height: 8,),
                      Text("\$120",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.redAccent
                      ),)
                    ],
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF475269),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Check Out",style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight:FontWeight.bold
                        ),),
                    ),
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
