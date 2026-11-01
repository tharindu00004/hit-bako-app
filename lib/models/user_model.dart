enum UserRole {
  member,
  superAdmin,
}

class AppUser {
  final String id;
  final String name;
  final String phoneOrEmail;
  final UserRole role;
  final String? district;
  final bool isVerified;

  AppUser({
    required this.id,
    required this.name,
    required this.phoneOrEmail,
    required this.role,
    this.district,
    this.isVerified = false,
  });

  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isMember => role == UserRole.member;
}
