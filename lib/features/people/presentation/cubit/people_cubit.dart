import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_people.dart';
import '../../domain/usecases/search_people.dart';
import 'people_state.dart';

class PeopleCubit extends Cubit<PeopleState> {
  final GetPopularPeople getPopularPeople;
  final SearchPeople searchPeopleUsecase;

  PeopleCubit({
    required this.getPopularPeople,
    required this.searchPeopleUsecase,
  }) : super(PeopleInitial());

  int _currentPage = 1;

  Future<void> fetchPopularPeople() async {
    if (state is PeopleLoading) return;
    
    emit(PeopleLoading());
    _currentPage = 1;
    
    final failureOrPeople = await getPopularPeople(_currentPage);
    
    failureOrPeople.fold(
      (failure) => emit(PeopleError(failure.message)),
      (people) => emit(PeopleLoaded(people: people, currentPage: _currentPage, hasReachedMax: people.isEmpty)),
    );
  }

  Future<void> fetchMorePopularPeople() async {
    final currentState = state;
    if (currentState is PeopleLoaded && !currentState.hasReachedMax) {
      _currentPage++;
      final failureOrPeople = await getPopularPeople(_currentPage);
      
      failureOrPeople.fold(
        (failure) => emit(PeopleError(failure.message)),
        (people) {
          emit(people.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : PeopleLoaded(
                  people: currentState.people + people,
                  hasReachedMax: false,
                  currentPage: _currentPage,
                ));
        },
      );
    }
  }

  Future<void> searchPeople(String query) async {
    if (query.isEmpty) {
      fetchPopularPeople();
      return;
    }
    emit(SearchLoading());
    
    final failureOrPeople = await searchPeopleUsecase(query, 1);
    
    failureOrPeople.fold(
      (failure) => emit(PeopleError(failure.message)),
      (people) => emit(SearchLoaded(people)),
    );
  }
}
