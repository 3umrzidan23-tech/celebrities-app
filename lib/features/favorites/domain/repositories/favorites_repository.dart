import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../people/domain/entities/person.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Person>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(Person person);
  Future<Either<Failure, void>> removeFavorite(int personId);
  Future<Either<Failure, bool>> isFavorite(int personId);
}
