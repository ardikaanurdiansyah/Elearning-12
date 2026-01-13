import 'package:shared_preferences/shared_preferences.dart';

class LocalService {
  static const String keyData = 'data';

  Future<List<String>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(keyData) ?? [];
  }

  Future<void> addData(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(keyData) ?? [];
    data.add(name);
    await prefs.setStringList(keyData, data);
  }

  Future<void> deleteData(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(keyData) ?? [];
    data.removeAt(index);
    await prefs.setStringList(keyData, data);
  }
}
