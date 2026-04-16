import 'package:shared_preferences/shared_preferences.dart';

class AudioSettings {
  static const String _soundKey = "sound_enabled";

  // الحصول على حالة الصوت (مفعل افتراضياً)
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_soundKey) ?? true;
  }

  // تغيير حالة الصوت (يستخدم في صفحة الإعدادات لاحقاً)
  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, enabled);
  }
}