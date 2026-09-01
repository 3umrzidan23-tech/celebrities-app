// Imports removed as AI API is temporarily disabled

abstract class AiRemoteDataSource {
  Future<String> sendMessage(String message);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  AiRemoteDataSourceImpl();

  @override
  Future<String> sendMessage(String message) async {
    // AI functionality is temporarily disabled.
    return "AI Assistant is currently offline. Please try again later.";
  }
}
