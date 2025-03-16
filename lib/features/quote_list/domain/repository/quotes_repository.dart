import 'package:dartz/dartz.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/features/quote_list/domain/model/quotes_model.dart';

abstract class QuotesRepository {
  Future<Either<Failure, QuotesModel>> getQuotes(int page);
}