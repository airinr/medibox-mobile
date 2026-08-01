import 'package:get/get.dart';
import '../../../app/core/constants/api_constants.dart';
import '../../../app/core/network/dio_client.dart';
import '../../models/auth_models.dart';

class AuthProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<ProfileData> getProfile(String userId) async {
    final response = await _dioClient.get(ApiConstants.profile(userId));
    return ProfileData.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? password,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null && fullName.isNotEmpty) data['full_name'] = fullName;
    if (email != null && email.isNotEmpty) data['email'] = email;
    if (password != null && password.isNotEmpty) data['password'] = password;
    await _dioClient.put(ApiConstants.updateProfile(userId), data: data);
  }

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final data = <String, dynamic>{
      'email': email,
      'password': password,
    };
    if (fullName != null && fullName.isNotEmpty) {
      data['full_name'] = fullName;
    }
    final response = await _dioClient.post(
      ApiConstants.register,
      data: data,
    );
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
