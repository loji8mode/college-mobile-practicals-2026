import 'package:shared_preferences/shared_preferences.dart';

abstract class SortSettings {
  Future<bool> load();
  Future<void> save(bool oldestFirst);
}

class PreferenceSortSettings implements SortSettings {
  final _preferences = SharedPreferencesAsync();
  @override
  Future<bool> load() async =>
      await _preferences.getBool('oldest_first') ?? false;
  @override
  Future<void> save(bool oldestFirst) =>
      _preferences.setBool('oldest_first', oldestFirst);
}

String displayDate(DateTime date) {
  final d = date.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
}
