class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'An error occurred with the server.']);
}

class OfflineException implements Exception {
  final String message;
  OfflineException([this.message = 'No internet connection.']);
}
