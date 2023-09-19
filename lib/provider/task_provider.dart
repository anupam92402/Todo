import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier{
  String _title = '';

  String get title=>_title;

  set title(value){
    _title = value;
    notifyListeners();
  }
}