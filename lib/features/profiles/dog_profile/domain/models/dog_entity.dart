class DogEntity {
  final String dogId;
  final String name;
  final String breed;
  final String gender;
  final String age;
  final String weightKg;
  final String location;
  final String imageURL;
  final List<String>? likes;
  final List<String>? dislikes;
  final String? bloodline;
  final String? healthReportUrl;

  DogEntity({
    required this.dogId,
    required this.name,
    required this.breed,
    required this.gender,
    required this.age,
    required this.weightKg,
    required this.location,
    required this.imageURL,
    this.bloodline,
    this.healthReportUrl,
    this.likes,
    this.dislikes,
  });

  DogEntity copyWith({
    String? newName,
    String? newBreed,
    String? newGender,
    String? newAge,
    String? newWeightKg,
    String? newWeightG,
    String? newHealthConditions,
    String? newLocation,
    String? newImageURL,
    String? newBloodline,
    String? newHealthReportUrl,
  }) {
    return DogEntity(
      dogId: dogId,
      name: newName ?? name,
      breed: newBreed ?? breed,
      gender: newGender ?? gender,
      age: newAge ?? age,
      weightKg: newWeightKg ?? weightKg,
      location: newLocation ?? location,
      imageURL: newImageURL ?? imageURL,
      bloodline: newBloodline ?? bloodline,
      healthReportUrl: newHealthReportUrl ?? healthReportUrl,
    );
  }

  factory DogEntity.fromJson(Map<String, dynamic> json) {
    return DogEntity(
      dogId: json['dog_id'],
      name: json['name'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'],
      weightKg: json['weightKg'],
      location: json['location'],
      imageURL: json['imageUrl'],
      likes: json['likes'] != null ? List<String>.from(json['likes']) : [],
      dislikes:
          json['dislikes'] != null ? List<String>.from(json['dislikes']) : [],
      bloodline: json['bloodline'],
      healthReportUrl: json['healthReportUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dog_id': dogId,
      'name': name,
      'breed': breed,
      'gender': gender,
      'age': age,
      'weightKg': weightKg,
      'location': location,
      'imageUrl': imageURL,
      'likes': likes,
      'dislikes': dislikes,
      'bloodline': bloodline,
      'healthReportUrl': healthReportUrl,
    };
  }
}
