import 'package:flutter/cupertino.dart';

class GapWidget extends StatelessWidget {
  final double size;
  GapWidget({this.size = 0.0});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 16 + size,
      width: 16 + size,
    );
  }
}
