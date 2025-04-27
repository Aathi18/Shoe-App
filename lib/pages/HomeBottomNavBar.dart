import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app/pages/BottomCartSheet.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class Homebottomnavbar extends StatelessWidget {
  const Homebottomnavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height:65 ,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF475269),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.category_outlined,color: Colors.white,
          size: 32,),
          InkWell(
            onTap: (){
              showSlidingBottomSheet(context, builder: (context){
                return SlidingSheetDialog(
                  elevation: 8,
                  cornerRadius: 16,
                  builder: (context,state){
                    return Bottomcartsheet();
                  }
                );
              }
              );
            },
            child: Icon(CupertinoIcons.cart_fill,color: Colors.white,
              size: 32,),
          ),
          Icon(Icons.favorite_border,color: Colors.white,
            size: 32,),
          Icon(Icons.person,color: Colors.white,
            size: 32,),
        ],
      ) ,
    );
  }
}
