import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(child: Text(StringConstants.settings)),
      ),
    );
  }
}
