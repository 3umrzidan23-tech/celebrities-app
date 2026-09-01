import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person.dart';
import '../repositories/person_repository.dart';

class SearchPeople {
  final PersonRepository repository;

  SearchPeople(this.repository);

  Future<Either<Failure, List<Person>>> call(String query, int page) async {
    return await repository.searchPeople(query, page);
  }
}
