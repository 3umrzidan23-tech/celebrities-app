import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AiRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> sendMessage(String message) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendMessage(message);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure('Failed to communicate with AI Assistant.'));
      }
    } else {
      return Left(ServerFailure('No internet connection.'));
    }
  }
}
