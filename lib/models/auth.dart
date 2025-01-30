class AuthenticationCredentials {
  final String key;
  final String secret;

  AuthenticationCredentials({
    required this.key,
    required this.secret,
  });

  factory AuthenticationCredentials.fromJson(Map<String, dynamic> json) =>
      AuthenticationCredentials(
        key: json['key'],
        secret: json['secret'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'secret': secret,
      };
}
