import 'package:flutter/material.dart';

class FontSpace with ChangeNotifier {
  double _fontSpaceSet = 2.0;

  double get fontSpaceSet => _fontSpaceSet;

  /// 是否点击了大行距
  bool _isTapLarge = false;

  bool get tapLargeFontSpace => _isTapLarge;

  /// 是否点击了中行距

  bool _isTapMid = false;

  bool get tapMidFontSpace => _isTapMid;

  /// 是否点击了小行距
  bool _isTapSmall = false;

  bool get tapSmallFontSpace => _isTapSmall;

  /// 大行距
  void setLargeFontSpace() {
    _fontSpaceSet = 3.0;
    _isTapLarge = true;
    _isTapMid = false;
    _isTapSmall = false;
    notifyListeners();
  }

  /// 中行距
  void setMidFontSpace() {
    _fontSpaceSet = 2.3;
    _isTapLarge = false;
    _isTapMid = true;
    _isTapSmall = false;
    notifyListeners();
  }

  /// 小行距
  void setSmallFontSpace() {
    _fontSpaceSet = 1.6;
    _isTapLarge = false;
    _isTapMid = false;
    _isTapSmall = true;
    notifyListeners();
  }
}
