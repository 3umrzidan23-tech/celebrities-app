import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../people/data/models/person_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<PersonModel>> getFavorites();
  Future<void> addFavorite(PersonModel person);
  Future<void> removeFavorite(int personId);
  Future<bool> isFavorite(int personId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String favoritesKey = 'CACHED_FAVORITES';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getFavorites() async {
    final jsonString = sharedPreferences.getStringList(favoritesKey);
    if (jsonString != null) {
      return jsonString
          .map((e) => PersonModel.fromJson(json.decode(e)))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addFavorite(PersonModel person) async {
    final favorites = await getFavorites();
    if (!favorites.any((e) => e.id == person.id)) {
      favorites.add(person);
      final jsonList = favorites
          .map((e) => json.encode({
                'id': e.id,
                'name': e.name,
                'profile_path': e.profilePath,
                'known_for_department': e.knownForDepartment,
                'popularity': e.popularity,
              }))
          .toList();
      await sharedPreferences.setStringList(favoritesKey, jsonList);
    }
  }

  @override
  Future<void> removeFavorite(int personId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((e) => e.id == personId);
    final jsonList = favorites
        .map((e) => json.encode({
              'id': e.id,
              'name': e.name,
              'profile_path': e.profilePath,
              'known_for_department': e.knownForDepartment,
              'popularity': e.popularity,
            }))
        .toList();
    await sharedPreferences.setStringList(favoritesKey, jsonList);
  }

  @override
  Future<bool> isFavorite(int personId) async {
    final favorites = await getFavorites();
    return favorites.any((e) => e.id == personId);
  }
}
