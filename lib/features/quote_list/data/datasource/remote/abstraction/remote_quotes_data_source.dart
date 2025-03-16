import 'package:quotes/features/quote_list/data/datasource/remote/dto/quotes_dto.dart';

abstract class RemoteQuotesDataSource {
   Future<QuotesDto> getQuotes(int page);
}