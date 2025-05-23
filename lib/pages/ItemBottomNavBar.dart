import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


import 'BottomCartSheet.dart';

class Itembottomnavbar extends StatelessWidget {
  const Itembottomnavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Color(0xFFF5F9FD),
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
            decoration: BoxDecoration(
              color: Color(0xFF475269),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF475269).withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]
            ),
            child:Row(
              children: [
                Text("Add To Cart",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),),
                SizedBox(width: 10,),
                Icon(CupertinoIcons.cart_badge_plus,
                color: Colors.white,
                size: 32,),

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
            decoration: BoxDecoration(
                color: Color(0xFF475269),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF475269).withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]
            ),
            child:
    InkWell(
    onTap: (){
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Bottomcartsheet(),
      );

    },
      child: Icon(Icons.shopping_bag,
        color: Colors.white,
        size: 45,),
    ),),
        ],
      ),
    );
  }
}
