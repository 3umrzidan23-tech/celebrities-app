import '../../domain/entities/person_details.dart';

class PersonDetailsModel extends PersonDetails {
  const PersonDetailsModel({
    required super.id,
    required super.name,
    required super.biography,
    super.birthday,
    super.placeOfBirth,
    super.profilePath,
    required super.knownForDepartment,
  });

  factory PersonDetailsModel.fromJson(Map<String, dynamic> json) {
    return PersonDetailsModel(
      id: json['id'],
      name: json['name'] ?? '',
      biography: json['biography'] ?? '',
      birthday: json['birthday'],
      placeOfBirth: json['place_of_birth'],
      profilePath: json['profile_path'],
      knownForDepartment: json['known_for_department'] ?? '',
    );
  }
}
