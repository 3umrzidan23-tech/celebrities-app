import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class CheckIfFavorite {
  final FavoritesRepository repository;

  CheckIfFavorite(this.repository);

  Future<Either<Failure, bool>> call(int personId) async {
    return await repository.isFavorite(personId);
  }
}
