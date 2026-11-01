import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'admin_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.member;
  final TextEditingController _identifierController =
      TextEditingController(text: '077 123 4567');
  final TextEditingController _passwordController =
      TextEditingController(text: 'secret123');
  final TextEditingController _adminKeyController =
      TextEditingController(text: '9999');

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  void _onRoleChanged(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.superAdmin) {
        _identifierController.text = 'admin@hitbako.lk';
      } else {
        _identifierController.text = '077 123 4567';
      }
    });
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    bool success = false;
    if (_selectedRole == UserRole.superAdmin) {
      success = await AuthService().loginSuperAdmin(
        email: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
        adminPasskey: _adminKeyController.text.trim(),
      );

      if (!success) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('❌ වැරදි Admin Passkey එකක්! (Default: 9999)'),
            ),
          );
        }
        return;
      }
    } else {
      success = await AuthService().loginMember(
        phoneOrEmail: _identifierController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (mounted && success) {
      if (_selectedRole == UserRole.superAdmin) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminDashboardScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }

  void _showRegisterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceNavy,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'නව සාමාජික ලියාපදිංචිය (Sign Up)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildSimpleField('සම්පූර්ණ නම', 'උදා: කසුන් පෙරේරා'),
              const SizedBox(height: 10),
              _buildSimpleField('දුරකථන අංකය', '077 123 4567',
                  keyboard: TextInputType.phone),
              const SizedBox(height: 10),
              _buildSimpleField('මුරපදය', '••••••••', isPassword: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onRoleChanged(UserRole.member);
                    _handleLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ලියාපදිංචි වී පිවිසෙන්න',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleField(String label, String hint,
      {bool isPassword = false, TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textIceBlue, fontSize: 12),
        ),
        const SizedBox(height: 4),
        TextField(
          obscureText: isPassword,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: Color(0x6693C5FD), fontSize: 12),
            filled: true,
            fillColor: const Color(0xFF0C2458),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0x4038BDF8)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = _selectedRole == UserRole.superAdmin;

    return Scaffold(
      backgroundColor: AppColors.backgroundNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              // Animated Circular Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF03153B),
                  border: Border.all(
                    color: isAdmin ? AppColors.goldYellow : AppColors.cyanAccent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isAdmin
                              ? AppColors.goldYellow
                              : AppColors.cyanAccent)
                          .withOpacity(0.35),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isAdmin
                        ? Icons.admin_panel_settings_rounded
                        : Icons.agriculture_rounded,
                    color: isAdmin ? AppColors.goldYellow : AppColors.cyanAccent,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Brand Title
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'HIT ',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'BAKO',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: AppColors.cyanAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'මිලදී ගන්න • විකුණන්න • කුලියට',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textIceBlue,
                ),
              ),
              const Text(
                'ශ්‍රී ලංකාවේ ප්‍රමුඛතම බර යන්ත්‍රෝපකරණ ජාලය',
                style: TextStyle(fontSize: 11, color: Color(0x9993C5FD)),
              ),
              const SizedBox(height: 24),

              // Role Toggle Buttons (Member vs Super Admin)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF05173E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x4D38BDF8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onRoleChanged(UserRole.member),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isAdmin
                                ? const Color(0xFF1D4ED8)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_rounded,
                                size: 16,
                                color: !isAdmin ? Colors.white : AppColors.textIceBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'සාමාජික (Member)',
                                style: TextStyle(
                                  color: !isAdmin ? Colors.white : AppColors.textIceBlue,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _onRoleChanged(UserRole.superAdmin),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isAdmin
                                ? AppColors.goldYellow
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shield_rounded,
                                size: 16,
                                color: isAdmin ? Colors.black : AppColors.goldYellow,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'පරිපාලක (Admin)',
                                style: TextStyle(
                                  color: isAdmin ? Colors.black : AppColors.goldYellow,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Role Description Hint
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isAdmin
                      ? const Color(0x20F59E0B)
                      : const Color(0x2000C2FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAdmin
                        ? const Color(0x40F59E0B)
                        : const Color(0x4000C2FF),
                  ),
                ),
                child: Text(
                  isAdmin
                      ? '👑 Super Admin: දැන්වීම් අනුමත කිරීම සහ පරිපාලන පාලනය'
                      : '💡 සාමාජික: යන්ත්‍ර මිලදී ගැනීම, විකිණීම සහ කුලියට දීම',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isAdmin ? AppColors.goldYellow : AppColors.cyanAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Input: Phone or Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isAdmin
                      ? 'පරිපාලක ඊමේල් (Admin Email):'
                      : 'දුරකථන අංකය හෝ විද්‍යුත් තැපෑල:',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _identifierController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.account_circle_rounded,
                    color: AppColors.cyanAccent,
                    size: 20,
                  ),
                  hintText: isAdmin ? 'admin@hitbako.lk' : '077 123 4567',
                  hintStyle: const TextStyle(color: Color(0x6693C5FD)),
                  filled: true,
                  fillColor: const Color(0xFF0C2458),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x6638BDF8)),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Input: Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'මුරපදය (Password):',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.cyanAccent,
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textIceBlue,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: Color(0x6693C5FD)),
                  filled: true,
                  fillColor: const Color(0xFF0C2458),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0x6638BDF8)),
                  ),
                ),
              ),

              // Admin Passkey Box (if Super Admin)
              if (isAdmin) ...[
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(Icons.key_rounded,
                          color: AppColors.goldYellow, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'පරිපාලක ආරක්ෂණ Passkey (Default: 9999):',
                        style: TextStyle(
                          color: AppColors.goldYellow,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _adminKeyController,
                  obscureText: true,
                  style: const TextStyle(
                    color: AppColors.goldYellow,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.security_rounded,
                      color: AppColors.goldYellow,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0C2458),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.goldYellow),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 22),

              // Submit Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isAdmin ? AppColors.goldYellow : AppColors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isAdmin
                                  ? 'පරිපාලක ලෙස ඇතුල් වන්න (Admin Log In)'
                                  : 'ඇතුල් වන්න (Log In)',
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 18),

              // Quick 1-Click Test Access
              const Divider(color: Color(0x3338BDF8)),
              const SizedBox(height: 8),
              const Text(
                '⚡ ක්ෂණික පරීක්ෂාව සඳහා (Quick Demo Access):',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0x9993C5FD),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _onRoleChanged(UserRole.member);
                        _handleLogin();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cyanAccent,
                        side: const BorderSide(color: Color(0x6600C2FF)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '👤 Member Demo',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _onRoleChanged(UserRole.superAdmin);
                        _handleLogin();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.goldYellow,
                        side: const BorderSide(color: Color(0x66FFC107)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '👑 Admin Demo',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'නව සාමාජිකයෙක්ද? ',
                    style: TextStyle(color: Color(0xCC93C5FD), fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: _showRegisterSheet,
                    child: const Text(
                      'ගිණුමක් සාදන්න (Sign Up)',
                      style: TextStyle(
                        color: AppColors.cyanAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
