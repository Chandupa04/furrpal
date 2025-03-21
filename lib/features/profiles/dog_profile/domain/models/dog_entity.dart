class DogEntity {
  final String dogId;
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String? healthConditions;
  final String location;
  final String imageURL;

  DogEntity({
    required this.dogId,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    this.healthConditions,
    required this.location,
    required this.imageURL,
  });

  DogEntity copyWith({
    String? newName,
    String? newBreed,
    String? newGender,
    String? newAge,
    String? newHealthConditions,
    String? newLocation,
    String? newImageURL,
  }) {
    return DogEntity(
      dogId: dogId,
      name: newName ?? name,
      breed: newBreed ?? breed,
      gender: newGender ?? gender,
      age: newAge ?? age,
      healthConditions: newHealthConditions ?? healthConditions,
      location: newLocation ?? location,
      imageURL: newImageURL ?? imageURL,
    );
  }

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
