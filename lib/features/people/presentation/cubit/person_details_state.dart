import 'package:equatable/equatable.dart';
import '../../domain/entities/person_details.dart';
import '../../domain/entities/person_image.dart';

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

  const PersonDetailsLoaded({
    required this.details,
    required this.images,
  });

  @override
  List<Object> get props => [details, images];
}

class PersonDetailsError extends PersonDetailsState {
  final String message;

  const PersonDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
