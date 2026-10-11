import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person_credit.dart';
import '../repositories/person_repository.dart';

class GetPersonCredits {
  final PersonRepository repository;

  GetPersonCredits(this.repository);

  Future<Either<Failure, List<PersonCredit>>> call(int id) async {
    return await repository.getPersonCredits(id);
  }
}
