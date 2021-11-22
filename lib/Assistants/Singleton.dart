import 'package:flutter/cupertino.dart';

class Singleton extends ChangeNotifier{
  static Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }
  int indexpage =0;

  void set setindex(int indexpage)
  {
    this.indexpage = indexpage;
    notifyListeners();
  }

  int get getindex
  {
    return indexpage;
  }

  Singleton._internal();

  
}