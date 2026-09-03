import 'package:isar_community/isar.dart';

abstract interface class ILocalStorage {
  Future<Isar> openDb();

  void clearDb();
}
