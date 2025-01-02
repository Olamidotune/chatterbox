import 'package:chatterbox/src/core/extentions/num_extention.dart';
import 'package:flutter/material.dart';

class AppSpacing {
  const AppSpacing._();

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  //vertical spacing
  static SizedBox verticalSpaceTiny = SizedBox(height: 4.height);
  static SizedBox verticalSpaceSmall = SizedBox(height: 8.height);
  static SizedBox verticalSpaceMedium = SizedBox(height: 16.height);
  static SizedBox verticalSpaceLarge = SizedBox(height: 25.height);
  static SizedBox verticalSpaceHuge = SizedBox(height: 30.height);
  static SizedBox verticalSpaceMassive = SizedBox(height: 40.height);

  static SizedBox verticalSpace(double height) {
    return SizedBox(height: height.height);
  }

  //horizontal spacing
  static SizedBox horizontalSpaceTiny = SizedBox(width: 4.width);
  static SizedBox horizontalSpaceSmall = SizedBox(width: 8.width);
  static SizedBox horizontalSpaceMedium = SizedBox(width: 16.width);
  static SizedBox horizontalSpaceLarge = SizedBox(width: 25.width);
  static SizedBox horizontalSpaceHuge = SizedBox(width: 30.width);
  static SizedBox horizontalSpaceMassive = SizedBox(width: 40.width);

  static SizedBox horizontalSpace(double width) {
    return SizedBox(width: width.width);
  }

  // vertical heights
  static double verticalTinyHeight = 4.height;
  static double verticalSmallHeight = 8.height;
  static double verticalMediumHeight = 10.height;
  static double verticalLargeHeight = 15.height;

  static SizedBox setHorizontalSpace(num w) => SizedBox(width: w.width);

  static double horizontalSpacing = 16.width;
  static double horizontalSpacingSmall = 8.width;
  static double horizontalSpacingMedium = 16.width;

  static SizedBox setVerticalSpace(num h) => SizedBox(height: h.height);
}
