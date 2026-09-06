class AcaddieUser {
  final String email;
  final String phone;
  final String password;
  final String varsityName;
  final String varsityId;
  final String address;
  final String fullName;

  AcaddieUser({
    required this.email,
    required this.phone,
    required this.password,
    required this.varsityName,
    required this.varsityId,
    required this.address,
    required this.fullName,
  });

  Map<String, String> toMap() => {
        'email': email,
        'phone': phone,
        'password': password,
        'varsityName': varsityName,
        'varsityId': varsityId,
        'address': address,
        'fullName': fullName,
      };

  factory AcaddieUser.fromMap(Map<String, String> m) => AcaddieUser(
        email: m['email'] ?? '',
        phone: m['phone'] ?? '',
        password: m['password'] ?? '',
        varsityName: m['varsityName'] ?? '',
        varsityId: m['varsityId'] ?? '',
        address: m['address'] ?? '',
        fullName: m['fullName'] ?? '',
      );
}
