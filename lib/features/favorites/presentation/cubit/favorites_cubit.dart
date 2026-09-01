import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../people/domain/entities/person.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/check_if_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/remove_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckIfFavorite checkIfFavorite;

  FavoritesCubit({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkIfFavorite,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    final failureOrFavorites = await getFavorites();
    failureOrFavorites.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        final favoriteIds = favorites.map((e) => e.id).toSet();
        emit(FavoritesLoaded(favorites, favoriteIds));
      },
    );
  }

  Future<void> toggleFavorite(Person person) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final isFav = currentState.favoriteIds.contains(person.id);
      
      if (isFav) {
        await removeFavorite(person.id);
      } else {
        await addFavorite(person);
      }
      
      // Reload to get updated list and IDs
      await loadFavorites();
    }
  }

  bool isFavorite(int id) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.favoriteIds.contains(id);
    }
    return false;
  }
}
