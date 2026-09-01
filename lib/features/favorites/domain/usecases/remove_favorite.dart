import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavorite {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  Future<Either<Failure, void>> call(int personId) async {
    return await repository.removeFavorite(personId);
  }
}
