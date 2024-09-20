import 'package:hive_flutter/hive_flutter.dart';

class UserDatabase {
  final userBox = Hive.box('User_Box');
  List users = [];
  void getData() {
    users = userBox.get('user');
  }

  void updataData() {
    userBox.put('user', users);
  }
}
