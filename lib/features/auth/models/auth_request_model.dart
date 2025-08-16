class AuthRequestModel {
  final String idToken;
  final String identityToken;
  final String userIdentifier;
  final String firstName;
  final String lastName;

  AuthRequestModel({
    this.idToken = '',
    this.identityToken = '',
    this.userIdentifier = '',
    this.firstName = '',
    this.lastName = '',
  });

  Map<String, dynamic> toJson() {
    return {
      "idToken": idToken,
      "identityToken": identityToken,
      "userIdentifier": userIdentifier,
      "firstName": firstName,
      "lastName": lastName,
    };
  }
}
