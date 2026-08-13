import '../models/user_model.dart';
import '../models/seller_model.dart';
import '../models/category_model.dart';
import '../models/resource_model.dart';

class DummyData {
  static UserModel currentUser = const UserModel(
    id: "1",
    name: "Krishnanand",
    email: "krishna@gmail.com",
    profileImage: "",
    isSeller: false,
    university: "TMBU",
    course: "BSc IT",
    semester: "Semester 3",
    phone: "",
  );

  static List<CategoryModel> categories = const [
    CategoryModel(
      id: "1",
      name: "Notes",
      icon: "📘",
    ),
    CategoryModel(
      id: "2",
      name: "PYQs",
      icon: "📄",
    ),
    CategoryModel(
      id: "3",
      name: "Books",
      icon: "📚",
    ),
    CategoryModel(
      id: "4",
      name: "Quiz",
      icon: "❓",
    ),
    CategoryModel(
      id: "5",
      name: "Assignments",
      icon: "📝",
    ),
  ];

  static SellerModel topSeller = const SellerModel(
    id: "11",
    name: "Krishnanand",
    profileImage: "",
    rating: 4.9,
    totalSales: 321,
    totalResources: 54,
  );

  static List<ResourceModel> resources = const [
    ResourceModel(
      id: "1",
      title: "Programming in C Notes",
      description: "Complete Notes",
      university: "TMBU",
      course: "BSc IT",
      semester: "Semester 3",
      subject: "Programming in C",
      category: "Notes",
      sellerId: "11",
      sellerName: "Krishnanand",
      price: 39.0,
      isFree: false,
      rating: 4.9,
      totalRatings: 120,
      downloads: 560,
      fileUrl: "",
      thumbnailUrl: "",
      isApproved: true,
    ),
    ResourceModel(
      id: "2",
      title: "Data Structure PYQ",
      description: "2022-2025 Papers",
      university: "TMBU",
      course: "BSc IT",
      semester: "Semester 3",
      subject: "Data Structure",
      category: "PYQs",
      sellerId: "12",
      sellerName: "Aman Kumar",
      price: 0.0,
      isFree: true,
      rating: 4.8,
      totalRatings: 95,
      downloads: 430,
      fileUrl: "",
      thumbnailUrl: "",
      isApproved: true,
    ),
    ResourceModel(
      id: "3",
      title: "Computer Network Notes",
      description: "Exam Notes",
      university: "TMBU",
      course: "BSc IT",
      semester: "Semester 3",
      subject: "Computer Network",
      category: "Notes",
      sellerId: "13",
      sellerName: "Rahul",
      price: 29.0,
      isFree: false,
      rating: 4.7,
      totalRatings: 82,
      downloads: 310,
      fileUrl: "",
      thumbnailUrl: "",
      isApproved: true,
    ),
  ];
}