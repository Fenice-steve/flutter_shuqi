import 'package:flutter/material.dart';

class NightChange with ChangeNotifier{
  
    Color readerViewColor;
    Color get isTapColor => readerViewColor;




    isTapButton(isTapButton){
      if(isTapButton){
        readerViewColor = Color(0xFF161616);
      }else{
        readerViewColor = Color(0xFFF6F6F6);
      }
      notifyListeners();
    }

}