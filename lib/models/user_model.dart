class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  final bool isSeller;

  final String university;
  final String course;
  final String semester;

  final String phone;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.isSeller,
    required this.university,
    required this.course,
    required this.semester,
    required this.phone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      profileImage: map["profileImage"] ?? "",
      isSeller: map["isSeller"] ?? false,
      university: map["university"] ?? "",
      course: map["course"] ?? "",
      semester: map["semester"] ?? "",
      phone: map["phone"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "isSeller": isSeller,
      "university": university,
      "course": course,
      "semester": semester,
      "phone": phone,
    };
  }
}