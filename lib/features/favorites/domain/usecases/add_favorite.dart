import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../people/domain/entities/person.dart';
import '../repositories/favorites_repository.dart';

class AddFavorite {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  Future<Either<Failure, void>> call(Person person) async {
    return await repository.addFavorite(person);
  }
}
