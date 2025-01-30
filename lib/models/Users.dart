class Users {
  final int id;
  final String firstName;
  final String lastName;
  final int mobileNo;

  Users({required this.id, required this.firstName, required this.lastName, required this.mobileNo});

  // // Convert a Map into a Librarymodel object
  // factory Librarymodel.fromMap(Map<String, dynamic> json) => Librarymodel(
  //   id: json['id'],
  //   firstName: json['firstName'],
  //   lastName: json['lastName'],
  //   mobileNo: json['mobileNo'],
  // );

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobileNo: json['mobileNo'],
    );

  
  }
  // // Convert a Librarymodel object into a Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'mobileNo': mobileNo,
  };
}
