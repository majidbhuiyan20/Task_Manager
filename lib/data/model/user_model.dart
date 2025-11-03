class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String photo;

  String get fullName{
    return "$firstName $lastName";
  }

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.photo,
  });
  factory UserModel.fromJson(Map<String, dynamic> jsonData){
    return UserModel(
        id: jsonData['_id'],
        email: jsonData['email'],
        firstName: jsonData['firstName'],
        lastName: jsonData['lastName'],
        mobile: jsonData['mobile'],
        photo: jsonData['photo'] ?? '',

        );
  }

  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'photo': photo,
    };
  }
}

// {"status":"success",
// "data":{"_id":"68dbe2e127e751dc7aeb0888",
// "email":"majid@gmail.com",
// "firstName":"abwefc",
// "lastName":"afwbc",
// "mobile":"017777777777",
// "createdDate":"2025-09-24T06:37:43.773Z"},
// "token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NTk0Nzc2NzksImRhdGEiOiJtYWppZEBnbWFpbC5jb20iLCJpYXQiOjE3NTkzOTEyNzl9.uI60m49vpseHkSsjav2VmO6TZcYPSPdPjHhjugRqeHA"}
