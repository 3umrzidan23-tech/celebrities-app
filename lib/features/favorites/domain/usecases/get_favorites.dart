import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../people/domain/entities/person.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  Future<Either<Failure, List<Person>>> call() async {
    return await repository.getFavorites();
  }
}
