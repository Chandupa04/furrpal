import 'dart:io';

class DogEntity {
  final String dogId;
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String healthConditions;
  final String location;
  final String? imageURL;

  DogEntity({
    required this.dogId,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.healthConditions,
    required this.location,
    this.imageURL,
  });

  factory DogEntity.fromJson(Map<String, dynamic> json) {
    return DogEntity(
      dogId: json['dog_id'],
      name: json['name'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      healthConditions: json['healthConditions'],
      location: json['location'],
      imageURL: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dog_id': dogId,
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'healthConditions': healthConditions,
      'location': location,
      'imageUrl': imageURL,
    };
  }
}
