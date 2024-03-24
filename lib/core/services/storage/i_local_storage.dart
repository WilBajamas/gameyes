import 'package:isar/isar.dart';


abstract interface class ILocalStorage {
  Future<Isar> openDb();

  void clearDb();
}
