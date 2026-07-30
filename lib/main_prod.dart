import 'package:gaming_library_assessment_flutter/bootstrap.dart';
import 'package:gaming_library_assessment_flutter/config/flavor/flavor.dart';
import 'package:gaming_library_assessment_flutter/main.dart';

Future<void> main() async {
  await bootstrap(flavor: Flavor.prod, app: const MyApp());
}
