import 'package:equatable/equatable.dart';
import '../../domain/entities/person_details.dart';
import '../../domain/entities/person_image.dart';
import '../../domain/entities/person_credit.dart';

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();

  @override
  List<Object> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {}

class PersonDetailsLoading extends PersonDetailsState {}

class PersonDetailsLoaded extends PersonDetailsState {
  final PersonDetails details;
  final List<PersonImage> images;
  final List<PersonCredit> credits;

  const PersonDetailsLoaded({
    required this.details,
    required this.images,
    required this.credits,
  });

  @override
  List<Object> get props => [details, images, credits];
}

class PersonDetailsError extends PersonDetailsState {
  final String message;

  const PersonDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
