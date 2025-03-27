import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/badge.dart';
import 'package:badges/badges.dart' as custom_badge;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(15),
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF475269).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]
                    ),
                    child: Icon(Icons.sort,
                    size: 30,
                    color: Color(0xFF475269),
                    ),
                  ),
                  Container(
                    padding:EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F9FD),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF475269).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        )
                      ]
                    ),
                    child: const Badge(
                        backgroundColor:Colors.redAccent,
                        padding:EdgeInsets.all(7),
                        label:Text("3",style: TextStyle(
                          color: Colors.white,
                        ),),
                      child: Icon(Icons.notifications,
                        size: 30,
                        color: Color(0xFF475269),
                      ),


                    ),
                        
                  )
                ],),),
                SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F9F0),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF475269).withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 5),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
