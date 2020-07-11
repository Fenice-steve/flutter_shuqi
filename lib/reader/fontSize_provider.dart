import 'package:flutter/material.dart';

class fontSize with ChangeNotifier{

  double _fontSizeSet = 10.0;
  double get fontSizeSet => _fontSizeSet;

  void setFontSize(font_size){
      _fontSizeSet = font_size;
      notifyListeners();
  }

}