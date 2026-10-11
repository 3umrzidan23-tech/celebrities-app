import '../../domain/entities/person_credit.dart';

class PersonCreditModel extends PersonCredit {
  const PersonCreditModel({
    required super.id,
    required super.title,
    super.posterPath,
    required super.mediaType,
    super.releaseDate,
    required super.role,
    required super.popularity,
  });

  factory PersonCreditModel.fromJson(Map<String, dynamic> json) {
    final isMovie = json['media_type'] == 'movie';
    return PersonCreditModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      posterPath: json['poster_path'],
      mediaType: json['media_type'] ?? 'unknown',
      releaseDate: isMovie ? json['release_date'] : json['first_air_date'],
      role: json['character'] ?? json['job'] ?? 'Unknown',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
