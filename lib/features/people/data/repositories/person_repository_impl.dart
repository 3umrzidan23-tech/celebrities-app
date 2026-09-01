import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_details.dart';
import '../../domain/entities/person_image.dart';
import '../../domain/repositories/person_repository.dart';
import '../datasources/person_remote_data_source.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Person>>> getPopularPeople(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getPopularPeople(page);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Person>>> searchPeople(String query, int page) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.searchPeople(query, page);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, PersonDetails>> getPersonDetails(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getPersonDetails(id);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<PersonImage>>> getPersonImages(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getPersonImages(id);
        return Right(remoteData);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
