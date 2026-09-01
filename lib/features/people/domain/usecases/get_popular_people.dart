import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person.dart';
import '../repositories/person_repository.dart';

class GetPopularPeople {
  final PersonRepository repository;

  GetPopularPeople(this.repository);

  Future<Either<Failure, List<Person>>> call(int page) async {
    return await repository.getPopularPeople(page);
  }
}
