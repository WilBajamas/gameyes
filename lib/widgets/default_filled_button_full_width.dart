import 'package:flutter/material.dart';

class DefaultFilledButtonFullWidth extends FilledButton {
  DefaultFilledButtonFullWidth(
    String text,
    Function()? onPressed, {
    double height = 48,
    super.key,
  }) : super(
          onPressed: onPressed,
          child: Text(text),
          style: FilledButton.styleFrom(
            minimumSize: Size.fromHeight(height),
          ),
        );
}
