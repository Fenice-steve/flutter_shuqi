import 'package:flutter/material.dart';

class BackgroundColor with ChangeNotifier {
  Color readerViewColor = Color(0xFFF6F6F6);

  Color get isTapColor => readerViewColor;

  Color textColor = Color(0xFF161616);

  Color get isChangeTextColor => textColor;

  isTapButton(bgType) {
    switch (bgType) {
      case "white":
        {
          readerViewColor = Color(0xFFF6F6F6);
          textColor = Color(0xFF3C2909);
        }
        break;
      case "yellow":
        {
          readerViewColor = Color(0xFFDED9C5);
          textColor = Color(0xFF3C2909);
        }
        break;
      case "green":
        {
          readerViewColor = Color(0xFFD7E3CB);
          textColor = Color(0xFF3C2909);
        }
        break;
      case "blue":
        {
          readerViewColor = Color(0xFFCCD8E4);
          textColor = Color(0xFF3C2909);
        }
        break;
      case "black":
        {
          readerViewColor = Color(0xFF161616);
          textColor = Color(0xFF707070);
        }
        break;
    }

    notifyListeners();
  }

  tapChangeTextColor(isTapButton) {
    if (isTapButton) {
      textColor = Color(0xFFF6F6F6);
    } else {
      textColor = Color(0xFF161616);
    }
    notifyListeners();
  }
}
