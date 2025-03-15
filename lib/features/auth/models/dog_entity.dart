import 'dart:io';

class DogEntity {
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String healthConditions;
  final String location;
  final File? imageFile;

  DogEntity({
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.healthConditions,
    required this.location,
    this.imageFile,
  });

  factory DogEntity.fromJson(Map<String, dynamic> json) {
    return DogEntity(
      name: json['name'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      healthConditions: json['healthConditions'],
      location: json['location'],
      imageFile: json['imageFile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'healthConditions': healthConditions,
      'location': location,
      'imageFile': imageFile?.path,
    };
  }
}
