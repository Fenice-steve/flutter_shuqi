import 'package:flutter/material.dart';

class NightChange with ChangeNotifier{
  
    Color readerViewColor = Color(0xFFF6F6F6);
    Color get isTapColor => readerViewColor;


    Color textColor = Color(0xFF161616);
    Color get isChangeTextColor =>textColor;



    isTapButton(isTapButton){
      if(isTapButton){
        readerViewColor = Color(0xFF161616);
      }else{
        readerViewColor = Color(0xFFF6F6F6);
      }
      notifyListeners();
    }

    tapChangeTextColor(isTapButton){
      if(isTapButton){
        textColor = Color(0xFFF6F6F6);
      }else{
        textColor = Color(0xFF161616);
      }
      notifyListeners();
    }

}