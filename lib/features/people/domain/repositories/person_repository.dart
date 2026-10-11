import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person.dart';
import '../entities/person_details.dart';
import '../entities/person_image.dart';
import '../entities/person_credit.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<Person>>> getPopularPeople(int page);
  Future<Either<Failure, List<Person>>> searchPeople(String query, int page);
  Future<Either<Failure, PersonDetails>> getPersonDetails(int id);
  Future<Either<Failure, List<PersonImage>>> getPersonImages(int id);
  Future<Either<Failure, List<PersonCredit>>> getPersonCredits(int id);
}
