import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quotes/core/error_handling/custom_exception.dart';
import 'package:quotes/core/utils/constants.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/abstraction/remote_quotes_data_source.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/dto/quotes_dto.dart';

class RemoteQuotesDataSourceImpl implements RemoteQuotesDataSource {
  final Dio _dio;
  
  RemoteQuotesDataSourceImpl(this._dio) {
    // Add interceptor once in constructor
    if (!_dio.interceptors.any((i) => i is LogInterceptor)) {
      _dio.interceptors.add(
        LogInterceptor(
          logPrint: (o) => debugPrint(o.toString()),
        ),
      );
    }
  }

  @override
  Future<QuotesDto> getQuotes(int page) async {
    try {
      final response = await _dio.get(
        "${Constants.baseUrl}quotes",
        queryParameters: {
          "page": page,
          "sortBy": "dateAdded",
          "language": "en",
        },
        options: Options(
          headers: {
            "X-Api-Key": dotenv.env["API_KEY"],
          },
        ),
      );
      if (response.statusCode == 200) {
        return QuotesDto.fromJson(response.data);
      } else {
        throw RestApiException(response.statusCode);
      }
    }
    on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw NoInternetConnectionException();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        throw Exception(e);
      }
    }
  }
}