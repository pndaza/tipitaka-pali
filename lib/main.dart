import 'package:flutter/material.dart';
import 'app.dart';
import 'package:tipitaka_pali/services/prefs.dart';

void main() async{


  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.
  await Prefs.init();



  runApp(App());
}