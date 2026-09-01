import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class AiRepository {
  Future<Either<Failure, String>> sendMessage(String message);
}
