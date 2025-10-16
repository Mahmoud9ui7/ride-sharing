class Person {
  int personID;
  String firstName;
  String secondName;
  String thirdName;
  String lastName;
  String nationalNo;
  DateTime dateOfBirth;
  int gendor;
  String address;
  String phone;
  String email;
  int nationalityCountryID;
  String imagePath;

  Person({
    this.personID = -1,
    this.firstName = '',
    this.secondName = '',
    this.thirdName = '',
    this.lastName = '',
    this.nationalNo = '',
    DateTime? dateOfBirth,
    this.gendor = 0,
    this.address = '',
    this.phone = '',
    this.email = '',
    this.nationalityCountryID = -1,
    this.imagePath = '',
  }) : dateOfBirth = dateOfBirth ?? DateTime.now();

  String get fullName =>
      '${firstName.trim()} ${secondName.trim()} ${thirdName.trim()} ${lastName.trim()}'
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        personID: json['personID'] ?? -1,
        firstName: json['firstName'] ?? '',
        secondName: json['secondName'] ?? '',
        thirdName: json['thirdName'] ?? '',
        lastName: json['lastName'] ?? '',
        nationalNo: json['nationalNo'] ?? '',
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.parse(json['dateOfBirth'])
            : DateTime.now(),
        gendor: json['gendor'] ?? 0,
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        nationalityCountryID: json['nationalityCountryID'] ?? -1,
        imagePath: json['imagePath'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'personID': personID,
        'firstName': firstName,
        'secondName': secondName,
        'thirdName': thirdName,
        'lastName': lastName,
        'nationalNo': nationalNo,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gendor': gendor,
        'address': address,
        'phone': phone,
        'email': email,
        'nationalityCountryID': nationalityCountryID,
        'imagePath': imagePath,
      };
}
