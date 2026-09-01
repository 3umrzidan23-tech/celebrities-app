import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../people/data/models/person_model.dart';
import '../../../people/domain/entities/person.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Person>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return const Left(ServerFailure('Failed to load favorites'));
    }
  }

  @override
  Future<Either<Failure, void>> addFavorite(Person person) async {
    try {
      final personModel = PersonModel(
        id: person.id,
        name: person.name,
        profilePath: person.profilePath,
        knownForDepartment: person.knownForDepartment,
        popularity: person.popularity,
      );
      await localDataSource.addFavorite(personModel);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to add favorite'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(int personId) async {
    try {
      await localDataSource.removeFavorite(personId);
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to remove favorite'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int personId) async {
    try {
      final isFav = await localDataSource.isFavorite(personId);
      return Right(isFav);
    } catch (e) {
      return const Left(ServerFailure('Failed to check favorite'));
    }
  }
}
