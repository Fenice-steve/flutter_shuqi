import 'package:flutter/material.dart';

class BackgroundColor with ChangeNotifier {
  Color readerViewColor = Color(0xFFF6F6F6);

  Color get isTapColor => readerViewColor;

  Color textColor = Color(0xFF161616);

  Color get isChangeTextColor => textColor;

  bool _isSelectedWhiteBack = false;

  bool get isSelectedWhiteBack => _isSelectedWhiteBack;

  bool _isSelectedYellowBack = false;

  bool get isSelectedYellowBack => _isSelectedYellowBack;

  bool _isSelectedGreenBack = false;

  bool get isSelectedGreenBack => _isSelectedGreenBack;

  bool _isSelectedBlueBack = false;

  bool get isSelectedBlueBack => _isSelectedBlueBack;

  bool _isSelectedBlackBack = false;

  bool get isSelectedBlackBack => _isSelectedBlackBack;

  isTapButton(bgType) {
    switch (bgType) {
      case "white":
        {
          readerViewColor = Color(0xFFF6F6F6);
          textColor = Color(0xFF3C2909);
          _isSelectedWhiteBack = true;
          _isSelectedBlackBack = false;
          _isSelectedBlueBack = false;
          _isSelectedGreenBack = false;
          _isSelectedYellowBack = false;
        }
        break;
      case "yellow":
        {
          readerViewColor = Color(0xFFDED9C5);
          textColor = Color(0xFF3C2909);
          _isSelectedWhiteBack = false;
          _isSelectedBlackBack = false;
          _isSelectedBlueBack = false;
          _isSelectedGreenBack = false;
          _isSelectedYellowBack = true;
        }
        break;
      case "green":
        {
          readerViewColor = Color(0xFFD7E3CB);
          textColor = Color(0xFF3C2909);
          _isSelectedWhiteBack = false;
          _isSelectedBlackBack = false;
          _isSelectedBlueBack = false;
          _isSelectedGreenBack = true;
          _isSelectedYellowBack = false;
        }
        break;
      case "blue":
        {
          readerViewColor = Color(0xFFCCD8E4);
          textColor = Color(0xFF3C2909);
          _isSelectedWhiteBack = false;
          _isSelectedBlackBack = false;
          _isSelectedBlueBack = true;
          _isSelectedGreenBack = false;
          _isSelectedYellowBack = false;
        }
        break;
      case "black":
        {
          readerViewColor = Color(0xFF161616);
          textColor = Color(0xFF707070);
          _isSelectedWhiteBack = false;
          _isSelectedBlackBack = true;
          _isSelectedBlueBack = false;
          _isSelectedGreenBack = false;
          _isSelectedYellowBack = false;
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
