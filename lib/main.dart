import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:shuqi/app/app_scene.dart';
import 'package:provider/provider.dart';
import 'package:shuqi/reader/fontSpace_provider.dart';
import 'reader/fontSize_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>fontSize()),
      ChangeNotifierProvider(create: (_)=>FontSpace()),
    ],
    child: AppScene(),
  ));

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
