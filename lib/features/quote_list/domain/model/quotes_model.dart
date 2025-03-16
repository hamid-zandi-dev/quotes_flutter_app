import 'quote_model.dart';

class QuotesModel {
  final String status;
  final num count;
  final num page;
  final num totalPages;
  final num totalCount;
  final num lastItemIndex;
  final List<QuoteModel> results;

  QuotesModel({
    this.status = "",
    this.count = 0,
    this.page = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.lastItemIndex = 0,
    required this.results,
  });
}
