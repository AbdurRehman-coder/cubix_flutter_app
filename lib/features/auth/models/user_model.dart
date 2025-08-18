class User {
  final String id;
  final String email;
  final String authProvider;
  final String authIdentifier;
  final String role;
  final String firstName;
  final String lastName;
  final String? fcmToken;
  final String? category;
  final bool verified;
  final bool banned;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.authProvider,
    required this.authIdentifier,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.fcmToken,
    this.category,
    required this.verified,
    required this.banned,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Empty user instance for fallback cases
  User.empty()
    : id = '',
      email = '',
      authProvider = '',
      authIdentifier = '',
      role = '',
      firstName = '',
      lastName = '',
      fcmToken = null,
      category = null,
      verified = false,
      banned = false,
      deleted = false,
      createdAt = DateTime.fromMicrosecondsSinceEpoch(0),
      updatedAt = DateTime.fromMicrosecondsSinceEpoch(0);

  factory User.fromJson(Map<String, dynamic>? json) {
    // Return empty user if json is null
    if (json == null) return User.empty();

    // Helper function for safe DateTime parsing
    DateTime parseDateTime(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.fromMicrosecondsSinceEpoch(0);
        }
      }
      return DateTime.fromMicrosecondsSinceEpoch(0);
    }

    return User(
      id:
          json.containsKey('_id') && json['_id'] is String
              ? json['_id'] as String
              : '',
      email:
          json.containsKey('email') && json['email'] is String
              ? json['email'] as String
              : '',
      authProvider:
          json.containsKey('authProvider') && json['authProvider'] is String
              ? json['authProvider'] as String
              : '',
      authIdentifier:
          json.containsKey('authIdentifier') && json['authIdentifier'] is String
              ? json['authIdentifier'] as String
              : '',
      role:
          json.containsKey('role') && json['role'] is String
              ? json['role'] as String
              : '',
      firstName:
          json.containsKey('firstName') && json['firstName'] is String
              ? json['firstName'] as String
              : '',
      lastName:
          json.containsKey('lastName') && json['lastName'] is String
              ? json['lastName'] as String
              : '',
      fcmToken:
          json.containsKey('fcmToken') && json['fcmToken'] is String
              ? json['fcmToken'] as String
              : null,
      category:
          json.containsKey('category') && json['category'] is String
              ? json['category'] as String
              : null,
      verified:
          json.containsKey('verified') && json['verified'] is bool
              ? json['verified'] as bool
              : false,
      banned:
          json.containsKey('banned') && json['banned'] is bool
              ? json['banned'] as bool
              : false,
      deleted:
          json.containsKey('deleted') && json['deleted'] is bool
              ? json['deleted'] as bool
              : false,
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
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
      "fcmToken": fcmToken,
      "category": category,
      "verified": verified,
      "banned": banned,
      "deleted": deleted,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}
