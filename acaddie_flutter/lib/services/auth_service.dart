import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const _keyLoggedIn = 'acaddie_logged_in';
  static const _keyEmail = 'acaddie_email';
  static const _keyPhone = 'acaddie_phone';
  static const _keyPassword = 'acaddie_password';
  static const _keyVarsityName = 'acaddie_varsity_name';
  static const _keyVarsityId = 'acaddie_varsity_id';
  static const _keyAddress = 'acaddie_address';
  static const _keyFullName = 'acaddie_full_name';

  // Check if user is already logged in
  static Future<AcaddieUser?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    return AcaddieUser(
      email: prefs.getString(_keyEmail) ?? '',
      phone: prefs.getString(_keyPhone) ?? '',
      password: prefs.getString(_keyPassword) ?? '',
      varsityName: prefs.getString(_keyVarsityName) ?? '',
      varsityId: prefs.getString(_keyVarsityId) ?? '',
      address: prefs.getString(_keyAddress) ?? '',
      fullName: prefs.getString(_keyFullName) ?? '',
    );
  }

  // Register a new account
  static Future<String?> register(AcaddieUser user) async {
    if (user.email.isEmpty || !user.email.contains('@')) {
      return 'সঠিক ইমেইল দিন';
    }
    if (user.password.length < 6) {
      return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
    }
    if (user.fullName.isEmpty) return 'পূর্ণ নাম দিন';
    if (user.varsityName.isEmpty) return 'বিশ্ববিদ্যালয়ের নাম দিন';
    if (user.varsityId.isEmpty) return 'বিশ্ববিদ্যালয় আইডি দিন';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyPhone, user.phone);
    await prefs.setString(_keyPassword, user.password);
    await prefs.setString(_keyVarsityName, user.varsityName);
    await prefs.setString(_keyVarsityId, user.varsityId);
    await prefs.setString(_keyAddress, user.address);
    await prefs.setString(_keyFullName, user.fullName);
    return null; // null = success
  }

  // Login with email + password
  static Future<String?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);

    if (storedEmail == null) return 'কোনো অ্যাকাউন্ট নেই। আগে রেজিস্ট্রেশন করুন।';
    if (storedEmail != email) return 'ইমেইল মিলছে না';
    if (storedPassword != password) return 'পাসওয়ার্ড ভুল';

    await prefs.setBool(_keyLoggedIn, true);
    return null; // null = success
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, false);
  }
}
