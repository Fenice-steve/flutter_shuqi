import 'package:flutter/material.dart';

/// 设置字号按钮
class SetFontSizeButton extends StatefulWidget {

  final VoidCallback onTap;
  final String title;
  final bool isTapFinish;

  const SetFontSizeButton({Key key, this.onTap, this.title, this.isTapFinish = false}) : super(key: key);


  @override
  _SetFontSizeButtonState createState() => _SetFontSizeButtonState();
}

class _SetFontSizeButtonState extends State<SetFontSizeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        alignment: Alignment.center,
        width: 150,
        height: 35,
        decoration: BoxDecoration(
          color: widget.isTapFinish?Color(0xFF3C3C3C) :Color(0xFF4F4F4F),
          borderRadius: BorderRadius.all(Radius.circular(34)),
        ),
        child: Text(widget.title,style: TextStyle(color: widget.isTapFinish ? Color(0xFF929292):Color(0xFFCFCFCF)),),
      ),

    );
  }
}

