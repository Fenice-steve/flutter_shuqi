import 'package:flutter/material.dart';

class fontSize with ChangeNotifier{

  /// 默认字号
  double _fontSizeSet = 16.0;
  double get fontSizeSet => _fontSizeSet;

  /// 是否点击到最大值
  bool _isTapToMax = false;
  bool get tapToMax => _isTapToMax;

  /// 是否减少到最小值
  bool _isTapToMin = false;
  bool get tapToMin => _isTapToMin;

  /// 增加字号
  void addFontSize(){
    _fontSizeSet ++;
    if(_fontSizeSet > 27){
      _fontSizeSet = 28;
      _isTapToMax = true;
    }
    if(_fontSizeSet>16 && _fontSizeSet<28){
      _isTapToMin = false;
    }
    notifyListeners();
  }


  /// 减小字号
  void downFontSize(){
    _fontSizeSet --;
    if(_fontSizeSet < 17){
      _fontSizeSet = 16;
      _isTapToMin = true;
    }
    if(_fontSizeSet>16 && _fontSizeSet<28){
      _isTapToMax =false;
    }
    notifyListeners();
  }

}