import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person_image.dart';
import '../repositories/person_repository.dart';

class GetPersonImages {
  final PersonRepository repository;

  GetPersonImages(this.repository);

  Future<Either<Failure, List<PersonImage>>> call(int id) async {
    return await repository.getPersonImages(id);
  }
}
