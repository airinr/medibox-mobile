class ProfileData {
  final String id;
  final String email;
  final String? fullName;

  ProfileData({required this.id, required this.email, this.fullName});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
    );
  }
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String userId;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      userId: json['user_id'] as String,
    );
  }
}
