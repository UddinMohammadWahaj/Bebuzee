import 'dart:ui';

import 'package:bizbultest/Language/appLocalization.dart';
import 'package:bizbultest/services/Properbuz/add_items_controller.dart';
import 'package:bizbultest/utilities/colors.dart';
import 'package:bizbultest/utilities/custom_icons.dart';
import 'package:bizbultest/view/Properbuz/add_items/add_New_tradesmen_view.dart';
import 'package:bizbultest/view/Properbuz/location_reviews_view.dart';
import 'package:bizbultest/view/Properbuz/my_review_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../add_items/write_review_view.dart';

class NewLocationViewPage extends GetView<AddItemsController> {
  const NewLocationViewPage({Key? key}) : super(key: key);

  Widget _customAddListTile(
      String title, IconData icon, VoidCallback onTap, BorderStyle style) {
    final double statusBarHeight =
        MediaQueryData.fromWindow(window).padding.top;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100.0.w,
        height: (100.0.h - (statusBarHeight)) / 3.65,
        color: Colors.white,
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border(
              top: BorderSide(
                  color: Colors.grey.shade300, width: 1, style: style),
              left: BorderSide(
                  color: Colors.grey.shade300, width: 1, style: style),
              bottom: BorderSide(
                  color: Colors.grey.shade300, width: 1, style: style),
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.black,
                size: 35,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: hotPropertiesThemeColor,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AddItemsController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hotPropertiesThemeColor,
        title: Text('Location Review'),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _customAddListTile(
                AppLocalizations.of("Write") +
                    " " +
                    AppLocalizations.of("Location") +
                    " " +
                    AppLocalizations.of(
                      "Reviews",
                    ),
                CustomIcons.review,
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          //  DetailedAddTradesmenView(),
                          WriteLocationReviewView(),
                    )),
                BorderStyle.solid),
            // _customAddListTile(
            //     AppLocalizations.of("My") +
            //         " " +
            //         AppLocalizations.of("Reviews"),
            //     CustomIcons.review,
            //     () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => MyLocationReviews(),
            //           // AddTradesmenView(null)
            //         )),
            //     BorderStyle.solid),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // _customAddListTile(
              //     AppLocalizations.of(
              //       "Search Location Reviews",
              //     ),
              //     CustomIcons.review,
              //     () => Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => SearchLocationReviews(),
              //           // AddTradesmenView(null)
              //         )),
              //     BorderStyle.solid),
            ],
          ),
          _customAddListTile(
              AppLocalizations.of("My") + " " + AppLocalizations.of("Reviews"),
              CustomIcons.review,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyLocationReviews(),
                    // AddTradesmenView(null)
                  )),
              BorderStyle.solid),
          _customAddListTile(
              AppLocalizations.of(
                "Search Location Reviews",
              ),
              CustomIcons.review,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchLocationReviews(),
                    // AddTradesmenView(null)
                  )),
              BorderStyle.solid),
        ]),
      ),
    );
  }
}
