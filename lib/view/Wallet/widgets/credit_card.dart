import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/credicarmiodle.dart';

class CreditCard extends StatelessWidget {
  final CreditCardModel? card;

  CreditCard({Key? key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Material(
      elevation: 1,
      shadowColor: Colors.grey.shade300,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: _media.width - 40,
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bebuzee Balance",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '\$ ${this.card!.money}',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0.h),
                ),
                SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: <Widget>[
                //     Text(
                //       "Expires",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.grey.shade400,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Text(card.expiryDate,
                //         style: Theme.of(context).textTheme.headline1.copyWith(
                //               color: Colors.black.withOpacity(0.5),
                //               fontWeight: FontWeight.bold,
                //             ))
                //   ],
                // )
              ],
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Container(
              height: 25,
              width: 50,
              color: Colors.pink,
              padding: EdgeInsets.all(7),
              child: Image.network(
                card!.logo,
                width: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
