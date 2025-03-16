class RestApiException implements Exception {
  final int? errorCode;
  RestApiException(this.errorCode);
}

class NoInternetConnectionException implements Exception {
  NoInternetConnectionException();
}