import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';

@singleton
class ScrollNotifier extends ChangeNotifier {
  bool scrolledForward = false;

  set isScrolled(ScrollDirection scrollDirection) {
    bool stateChanged = false;
    switch (scrollDirection) {
      case ScrollDirection.forward:
        if (!scrolledForward) {
          scrolledForward = true;
          stateChanged = true;
        }
        break;
      case ScrollDirection.reverse:
        if (scrolledForward) {
          scrolledForward = false;
          stateChanged = true;
        }
        break;
      case ScrollDirection.idle:
        break;
    }
    // Only notify listeners if the direction actually flipped
    if (stateChanged) {
      notifyListeners();
    }
  }
}
