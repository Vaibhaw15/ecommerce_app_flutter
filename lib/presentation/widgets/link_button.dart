import 'package:ecommerce_app/core/ui.dart';
import 'package:flutter/cupertino.dart';


class LinkButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  LinkButton({required this.text, this.onPressed,this.color});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Text(text,style: TextStyle(
        color: color ?? AppColors.accent,
      ),),
    );
  }
}
