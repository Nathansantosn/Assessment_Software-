import 'package:flutter/foundation.dart';
import 'package:assessment_software/models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Mock de usuários para demonstração (substitua por sua lógica real)
  final List<User> _mockUsers = [
    User(
      id: '1',
      name: 'Desenvolvedor',
      email: 'dev@teste.com',
      role: UserRole.developer,
      password: 'dev123',
    ),
    User(
      id: User.,
      name: 'Testador',
      email: 'tester@teste.com',
      role: UserRole.tester,
      password: 'tester123',
    ),
    User(
      id: '3',
      name: 'Gerente',
      email: 'manager@teste.com',
      role: UserRole.manager,
      password: 'manager123',
    ),
  ];

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);

      // Simula delay de rede
      await Future.delayed(const Duration(seconds: 1));

      // Encontra o usuário mockado (substitua por sua API real)
      final user = _mockUsers.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Credenciais inválidas'),
      );

      _currentUser = user;
      notifyListeners();
      return user;
    } catch (e) {
      _setLoading(false);
      throw Exception('Falha no login: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para registro (adicione conforme sua necessidade)
  Future<User?> register(
    String name,
    String email,
    String password,
    UserRole role,
  ) async {
    try {
      _setLoading(true);
      await Future.delayed(const Duration(seconds: 1));

      // Verifica se email já existe
      if (_mockUsers.any((user) => user.email == email)) {
        throw Exception('Email já cadastrado');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        password: password,
      );

      _mockUsers.add(newUser);
      _currentUser = newUser;
      notifyListeners();
      return newUser;
    } catch (e) {
      _setLoading(false);
      throw Exception('Falha no registro: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
}
