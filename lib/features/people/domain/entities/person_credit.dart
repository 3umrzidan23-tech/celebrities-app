import 'package:equatable/equatable.dart';

class PersonCredit extends Equatable {
  final int id;
  final String title;
  final String? posterPath;
  final String mediaType; // 'movie' or 'tv'
  final String? releaseDate;
  final String role; // character or job
  final double popularity;

  const PersonCredit({
    required this.id,
    required this.title,
    this.posterPath,
    required this.mediaType,
    this.releaseDate,
    required this.role,
    required this.popularity,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        mediaType,
        releaseDate,
        role,
        popularity,
      ];
}
