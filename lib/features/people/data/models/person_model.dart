import '../../domain/entities/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    super.profilePath,
    required super.knownForDepartment,
    required super.popularity,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'],
      name: json['name'] ?? '',
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'] ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
