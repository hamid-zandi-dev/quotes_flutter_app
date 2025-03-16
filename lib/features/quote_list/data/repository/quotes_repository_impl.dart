import 'package:dartz/dartz.dart';
import 'package:quotes/core/error_handling/custom_exception.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/core/utils/constants.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/abstraction/remote_quotes_data_source.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/dto/quotes_dto.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/mapper/remote_quotes_mapper.dart';
import 'package:quotes/features/quote_list/domain/model/quotes_model.dart';
import 'package:quotes/features/quote_list/domain/repository/quotes_repository.dart';

class QuotesRepositoryImpl extends QuotesRepository {

  final RemoteQuotesMapper _remoteQuoteMapper;
  final RemoteQuotesDataSource _remoteQuotesDataSource;
  final Map<int, Future<QuotesDto>> _pendingRequests = {};

  QuotesRepositoryImpl(
      this._remoteQuotesDataSource,
      this._remoteQuoteMapper);

  @override
  Future<Either<Failure, QuotesModel>> getQuotes(int page) async {
    try {
      if (_pendingRequests.containsKey(page)) {
        print('🔒 Repository: Request already in progress for page $page');
        final cachedResponse = await _pendingRequests[page]!;
        return right(_remoteQuoteMapper.mapToQuotesModel(cachedResponse));
      }
      
      final requestFuture = _remoteQuotesDataSource.getQuotes(page);
      _pendingRequests[page] = requestFuture;
      
      requestFuture.whenComplete(() {
        _pendingRequests.remove(page);
      });
      
      final response = await requestFuture;
      return right(_remoteQuoteMapper.mapToQuotesModel(response));
    }
    on NoInternetConnectionException {
      return left(Failure.noInternetConnectionError);
    }
    on RestApiException catch (e) {
      return left(_handleApiException(e));
    }
    catch(e) {
      return left(Failure.unknownError);
    }
  }

  Failure _handleApiException(RestApiException e) {
    if (e.errorCode != null) {
      if (e.errorCode! >= RestApiError.fromServerError && e.errorCode! <= RestApiError.toServerError) {
        return Failure.serverError;
      }
      return Failure.unknownError;
    }
    return Failure.unknownError;
  }
}