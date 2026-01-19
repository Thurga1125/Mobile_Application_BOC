class User {
  final String id;
  final String fullName;
  final String accountNumber;
  final String email;
  final String? phoneNumber;
  final String? profileImage;

  User({
    required this.id,
    required this.fullName,
    required this.accountNumber,
    required this.email,
    this.phoneNumber,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'accountNumber': accountNumber,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
    };
  }
}
