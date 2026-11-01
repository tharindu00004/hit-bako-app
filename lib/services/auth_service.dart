import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Member Login
  Future<bool> loginMember({
    required String phoneOrEmail,
    required String password,
  }) async {
    // In production, connect to Firebase Auth, Supabase, or REST API.
    await Future.delayed(const Duration(milliseconds: 600));

    _currentUser = AppUser(
      id: 'usr_mem_001',
      name: 'කසුන් පෙරේරා (Kasun Perera)',
      phoneOrEmail: phoneOrEmail,
      role: UserRole.member,
      district: 'කුරුණෑගල',
      isVerified: true,
    );
    notifyListeners();
    return true;
  }

  /// Super Admin Login with Passkey Protection
  Future<bool> loginSuperAdmin({
    required String email,
    required String password,
    required String adminPasskey,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Simple security validation for default admin key
    if (adminPasskey.trim() != '9999' && adminPasskey.isNotEmpty) {
      return false;
    }

    _currentUser = AppUser(
      id: 'usr_adm_001',
      name: 'ප්‍රධාන පරිපාලක (Super Admin)',
      phoneOrEmail: email.isEmpty ? 'admin@hitbako.lk' : email,
      role: UserRole.superAdmin,
      isVerified: true,
    );
    notifyListeners();
    return true;
  }

  /// Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
