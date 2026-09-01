import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person_details.dart';
import '../repositories/person_repository.dart';

class GetPersonDetails {
  final PersonRepository repository;

  GetPersonDetails(this.repository);

  Future<Either<Failure, PersonDetails>> call(int id) async {
    return await repository.getPersonDetails(id);
  }
}
