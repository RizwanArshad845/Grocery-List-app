class UserProfile {
  final String uid;
  final String? email;
  final String? name;

  UserProfile({
    required this.uid,
    this.email,
    this.name,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      email: data['email'] as String?,
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
    };
  }
}
