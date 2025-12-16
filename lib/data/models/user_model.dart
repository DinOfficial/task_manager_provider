class UserModel {
  final String id;
  final String email;
  final String firsName;
  final String lastName;
  final String mobile;
  final String photo;


  UserModel({
    required this.id,
    required this.email,
    required this.firsName,
    required this.lastName,
    required this.mobile,
    required this.photo,
  });


  factory UserModel.fromJson(Map<String, dynamic> jsonData){
    return UserModel(
        id: jsonData['_id'],
        email: jsonData['email'],
        firsName: jsonData['firstName'],
        lastName: jsonData['lastName'],
        mobile: jsonData['mobile'],
        photo: jsonData['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "firstName": firsName,
      "lastName": lastName,
      "mobile": mobile,
      "photo": photo,
    };
  }
}