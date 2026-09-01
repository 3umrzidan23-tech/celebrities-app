import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/person_details_model.dart';
import '../models/person_image_model.dart';
import '../models/person_model.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getPopularPeople(int page);
  Future<List<PersonModel>> searchPeople(String query, int page);
  Future<PersonDetailsModel> getPersonDetails(int id);
  Future<List<PersonImageModel>> getPersonImages(int id);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final ApiClient apiClient;

  PersonRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PersonModel>> getPopularPeople(int page) async {
    try {
      final response = await apiClient.get(
        ApiConstants.popularPersons,
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((e) => PersonModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<PersonModel>> searchPeople(String query, int page) async {
    try {
      final response = await apiClient.get(
        '/search/person',
        queryParameters: {'query': query, 'page': page},
      );
      if (response.statusCode == 200) {
        final List results = response.data['results'];
        return results.map((e) => PersonModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<PersonDetailsModel> getPersonDetails(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.personDetails(id));
      if (response.statusCode == 200) {
        return PersonDetailsModel.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<PersonImageModel>> getPersonImages(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.personImages(id));
      if (response.statusCode == 200) {
        final List results = response.data['profiles'];
        return results.map((e) => PersonImageModel.fromJson(e)).toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
