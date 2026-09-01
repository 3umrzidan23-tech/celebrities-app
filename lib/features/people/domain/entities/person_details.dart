import 'package:equatable/equatable.dart';

class PersonDetails extends Equatable {
  final int id;
  final String name;
  final String biography;
  final String? birthday;
  final String? placeOfBirth;
  final String? profilePath;
  final String knownForDepartment;

  const PersonDetails({
    required this.id,
    required this.name,
    required this.biography,
    this.birthday,
    this.placeOfBirth,
    this.profilePath,
    required this.knownForDepartment,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        biography,
        birthday,
        placeOfBirth,
        profilePath,
        knownForDepartment,
      ];
}
