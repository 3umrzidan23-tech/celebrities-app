import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class AiRemoteDataSource {
  Future<String> sendMessage(String message);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  @override
  Future<String> sendMessage(String message) async {
    if (ApiConstants.geminiApiKey.isEmpty ||
        ApiConstants.geminiApiKey.contains('GEMINI_KEY')) {
      return "AI Assistant is currently offline. Please configure GEMINI_API_KEY to activate.";
    }
    try {
      final response = await dio.post(
        '${ApiConstants.geminiUrl}?key=${ApiConstants.geminiApiKey}',
        data: {
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['candidates']?[0]['content']?['parts']?[0]['text'];
        if (content != null) {
          return content;
        }
        throw ServerException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
