import 'package:dartz/dartz.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/core/use_case/use_case.dart';
import 'package:quotes/features/quote_list/domain/model/quotes_model.dart';
import 'package:quotes/features/quote_list/domain/repository/quotes_repository.dart';

class GetQuotesUseCase extends UseCase<Either<Failure, QuotesModel>, GetQuotesParams> {
  final QuotesRepository _quotesRepository;
  GetQuotesUseCase(this._quotesRepository);

  @override
  Future<Either<Failure, QuotesModel>> call(GetQuotesParams input) {
    return _quotesRepository.getQuotes(input.page);
  }
}

class GetQuotesParams {
  final int page;

  GetQuotesParams._(this.page);

  static GetQuotesParams forQuery({required int page}) {
    return GetQuotesParams._(page);
  }
}