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

  const CircleSelectButton({
    Key key,
    this.isSelected,
    this.innerWidget,
    this.onTap,
    this.selectedColor
  }) : super(key: key);

  @override
  _CircleSelectButtonState createState() => _CircleSelectButtonState();
}

class _CircleSelectButtonState extends State<CircleSelectButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(30.5)),
          //设置四周边框
          border: new Border.all(
              width: 2,
              color:widget.selectedColor
//                  widget.isSelected ? Color(0xFF1C8AEC) : Color(0xFFCDCDCD)
          ),
        ),
        child: widget.innerWidget,
      ),
    );
  }
}
