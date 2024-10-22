class Librarymodel {
  final int id;
  final String firstName;
  final String lastName;
  final int mobileNo;

  Librarymodel({required this.id, required this.firstName, required this.lastName, required this.mobileNo});

  // // Convert a Map into a Librarymodel object
  // factory Librarymodel.fromMap(Map<String, dynamic> json) => Librarymodel(
  //   id: json['id'],
  //   firstName: json['firstName'],
  //   lastName: json['lastName'],
  //   mobileNo: json['mobileNo'],
  // );

  factory Librarymodel.fromJson(Map<String, dynamic> json) {
    return Librarymodel(
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
