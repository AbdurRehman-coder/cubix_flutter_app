class User {
  final String id;
  final String email;
  final String authProvider;
  final String authIdentifier;
  final String role;
  final String firstName;
  final String lastName;
  final bool verified;
  final bool banned;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.authIdentifier,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.verified,
    required this.banned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      authProvider: json['authProvider'] ?? '',
      authIdentifier: json['authIdentifier'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      verified: json['verified'] ?? false,
      banned: json['banned'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "authProvider": authProvider,
      "authIdentifier": authIdentifier,
      "role": role,
      "firstName": firstName,
      "lastName": lastName,
      "verified": verified,
      "banned": banned,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
