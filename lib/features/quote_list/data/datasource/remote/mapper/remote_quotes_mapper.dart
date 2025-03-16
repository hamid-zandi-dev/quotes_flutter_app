import 'package:quotes/core/utils/model_mapper.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/dto/quote_dto.dart';
import 'package:quotes/features/quote_list/data/datasource/remote/dto/quotes_dto.dart';
import 'package:quotes/features/quote_list/domain/model/quote_model.dart';
import 'package:quotes/features/quote_list/domain/model/quotes_model.dart';

class RemoteQuotesMapper extends ModelMapper<QuoteModel, QuoteDto> {

  @override
  QuoteDto mapFromModel(QuoteModel model) {
    return QuoteDto(
      id: model.id,
      author: model.author,
      content: model.content,
    );
  }

  @override
  QuoteModel mapToModel(QuoteDto dto) {
    return QuoteModel(
        id: dto.id ?? '',
        author: dto.author ?? '',
        content: dto.content ?? '');
  }

  QuotesModel mapToQuotesModel(QuotesDto quotesDto) {
    return QuotesModel(
        status: quotesDto.status ?? '',
        count: quotesDto.count ?? 0,
        page: quotesDto.page ?? 1,
        totalPages: quotesDto.totalPages ?? 1,
        totalCount: quotesDto.totalCount ?? 0,
        lastItemIndex: quotesDto.lastItemIndex ?? 0,
        results: quotesDto.results?.map((quoteDto) => mapToModel(quoteDto)).toList() ?? []
    );
  }

  QuotesDto mapToQuotesDto(QuotesModel quotesModel) {
    return QuotesDto(
        status: quotesModel.status,
        count: quotesModel.count,
        page: quotesModel.page,
        totalPages: quotesModel.totalPages,
        totalCount: quotesModel.totalCount,
        lastItemIndex: quotesModel.lastItemIndex,
        results: quotesModel.results.map((quoteModel) => mapFromModel(quoteModel)).toList()
    );
  }
}
