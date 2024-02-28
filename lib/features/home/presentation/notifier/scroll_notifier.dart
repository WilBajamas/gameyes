import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';

@singleton
class ScrollNotifier extends ChangeNotifier {
  bool scrolledForward = false;

  set isScrolled(ScrollDirection scrollDirection) {
    switch (scrollDirection) {
      case ScrollDirection.forward:
        scrolledForward = true;
        break;
      case ScrollDirection.reverse:
        scrolledForward = false;
        break;
      case ScrollDirection.idle:
        break;
    }

    notifyListeners();
  }
}
