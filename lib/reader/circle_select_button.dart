import 'package:flutter/material.dart';

/// 圆形选择按钮
class CircleSelectButton extends StatefulWidget {
  /// 是否已点选择
  final bool isSelected;

  /// 是否选择的颜色
  final Color selectedColor;

  /// 内部组件
  final Widget innerWidget;
  final VoidCallback onTap;

  const CircleSelectButton(
      {Key key,
      this.isSelected,
      this.innerWidget,
      this.onTap,
      this.selectedColor})
      : super(key: key);

  @override
  _CircleSelectButtonState createState() => _CircleSelectButtonState();
}

class _CircleSelectButtonState extends State<CircleSelectButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.5)),
          border: new Border.all(width: 2, color: widget.selectedColor
              ),
        ),
        child: widget.innerWidget,
      ),
    );
  }
}

/// 封装一个是否点击的按钮
class IsOnTapButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  final bool isTap;

  const IsOnTapButton({Key key, this.title, this.onTap, this.isTap})
      : super(key: key);

  @override
  _IsOnTapButtonState createState() => _IsOnTapButtonState();
}

class _IsOnTapButtonState extends State<IsOnTapButton> {
  var onColor = Color(0xFF1C8AEC);
  var offColor = Color(0xFF8F8F8F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 0,0,0),
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        decoration: BoxDecoration(
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(30.5)),
          //设置四周边框
          border: new Border.all(
              width: 1, color: widget.isTap ? onColor : offColor),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: TextStyle(
              color: widget.isTap ? onColor : offColor,
              fontSize: 15),
        ),
      ),
    );
  }
}
