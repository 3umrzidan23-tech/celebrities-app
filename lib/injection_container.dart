import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';

import 'features/ai_assistant/data/datasources/ai_remote_data_source.dart';
import 'features/ai_assistant/data/repositories/ai_repository_impl.dart';
import 'features/ai_assistant/domain/repositories/ai_repository.dart';
import 'features/ai_assistant/domain/usecases/send_message.dart';
import 'features/ai_assistant/presentation/cubit/ai_cubit.dart';

import 'features/favorites/data/datasources/favorites_local_data_source.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/add_favorite.dart';
import 'features/favorites/domain/usecases/check_if_favorite.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/remove_favorite.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/image_viewer/domain/usecases/download_image.dart';
import 'features/image_viewer/presentation/viewmodels/image_viewer_cubit.dart';
import 'features/people/data/datasources/person_remote_data_source.dart';
import 'features/people/data/repositories/person_repository_impl.dart';
import 'features/people/domain/repositories/person_repository.dart';
import 'features/people/domain/usecases/get_person_details.dart';
import 'features/people/domain/usecases/get_person_images.dart';
import 'features/people/domain/usecases/get_person_credits.dart';
import 'features/people/domain/usecases/get_popular_people.dart';
import 'features/people/domain/usecases/search_people.dart';
import 'features/people/presentation/cubit/people_cubit.dart';
import 'features/people/presentation/cubit/person_details_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - People
  // Cubit
  sl.registerFactory(() => PeopleCubit(getPopularPeople: sl(), searchPeopleUsecase: sl()));
  sl.registerFactory(() => PersonDetailsCubit(getPersonDetails: sl(), getPersonImages: sl(), getPersonCredits: sl()));

  // Features - Image Viewer
  // Cubit
  sl.registerFactory(() => ImageViewerCubit(downloadImageUseCase: sl()));
  sl.registerLazySingleton(() => DownloadImage(sl()));

  // Features - AI Assistant
  // Cubit
  sl.registerFactory(() => AiCubit(sendMessage: sl()));

  // Use cases
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<AiRepository>(
    () => AiRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AiRemoteDataSource>(
    () => AiRemoteDataSourceImpl(dio: sl()),
  );

  // Features - Favorites
  // Cubit
  sl.registerFactory(() => FavoritesCubit(getFavorites: sl(), addFavorite: sl(), removeFavorite: sl(), checkIfFavorite: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => CheckIfFavorite(sl()));

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(localDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(() => FavoritesLocalDataSourceImpl(sharedPreferences: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPopularPeople(sl()));
  sl.registerLazySingleton(() => SearchPeople(sl()));
  sl.registerLazySingleton(() => GetPersonDetails(sl()));
  sl.registerLazySingleton(() => GetPersonImages(sl()));
  sl.registerLazySingleton(() => GetPersonCredits(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PersonRemoteDataSource>(
    () => PersonRemoteDataSourceImpl(apiClient: sl()),
  );


  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiClient(dio: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnection());
}
