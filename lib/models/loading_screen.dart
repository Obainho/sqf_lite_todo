import 'package:flutter/material.dart';

class LoadScreen with ChangeNotifier {
  bool _doneLoading = false;
  bool get doneLoading => _doneLoading;

  set doneLoading(bool value) {
    _doneLoading = value;
    notifyListeners();
  }
}
