import 'package:flutter/cupertino.dart';

class CustomDecoration{
  static BoxDecoration setGradientBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          colors: [
            const Color(0xFFabbab),
            const Color(0xFFffffff),
          ],
          begin: const FractionalOffset(0.0, 1.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
    );
  }
}