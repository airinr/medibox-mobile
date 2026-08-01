import '../models/auth_models.dart';
import '../providers/remote/auth_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider;

  AuthRepository(this._authProvider);

  Future<ProfileData> getProfile(String userId) {
    return _authProvider.getProfile(userId);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) {
    return _authProvider.login(email: email, password: password);
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? password,
  }) {
    return _authProvider.updateProfile(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? fullName,
  }) {
    return _authProvider.register(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
