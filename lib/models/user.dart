enum UserRole { developer, tester, manager }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String password; // Add this line if missing

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password, // Add this line
  });
}
