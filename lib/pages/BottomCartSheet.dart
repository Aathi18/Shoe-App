import 'package:flutter/material.dart';

class Bottomcartsheet extends StatelessWidget {
  const Bottomcartsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Container(
                  margin: EdgeInsets.symmetric(vertical:10,horizontal: 15 ),
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
                        onTap: (){},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10,right: 60),
                              height: 90,
                              width: 100,
                              decoration: BoxDecoration(

                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
