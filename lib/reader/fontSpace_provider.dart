import 'package:flutter/material.dart';

class FontSpace with ChangeNotifier{

  double _fontSpaceSet = 2.0;
  double get fontSpaceSet => _fontSpaceSet;

  void setFontSpace(font_space){
    _fontSpaceSet = font_space;
    notifyListeners();
  }
}