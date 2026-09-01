import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/ai_repository.dart';

class SendMessage {
  final AiRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, String>> call(String message) async {
    return await repository.sendMessage(message);
  }
}
