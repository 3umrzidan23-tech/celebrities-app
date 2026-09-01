import 'package:equatable/equatable.dart';
import '../../domain/entities/person.dart';

abstract class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object> get props => [];
}

class PeopleInitial extends PeopleState {}

class PeopleLoading extends PeopleState {}

class PeopleLoaded extends PeopleState {
  final List<Person> people;
  final bool hasReachedMax;
  final int currentPage;

  const PeopleLoaded({
    required this.people,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  PeopleLoaded copyWith({
    List<Person>? people,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PeopleLoaded(
      people: people ?? this.people,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [people, hasReachedMax, currentPage];
}

class PeopleError extends PeopleState {
  final String message;

  const PeopleError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchLoading extends PeopleState {}

class SearchLoaded extends PeopleState {
  final List<Person> searchResults;
  const SearchLoaded(this.searchResults);
  
  @override
  List<Object> get props => [searchResults];
}
