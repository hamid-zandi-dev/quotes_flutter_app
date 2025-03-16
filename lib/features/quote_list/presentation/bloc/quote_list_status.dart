import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/features/quote_list/domain/model/quote_model.dart';

abstract class QuoteListStatus {}

class QuoteListLoadingStatus extends QuoteListStatus {}

class QuoteListLoadingMoreStatus extends QuoteListStatus {
  final List<QuoteModel> currentItems;
  
  QuoteListLoadingMoreStatus([this.currentItems = const []]);
}

class QuoteListEmptyStatus extends QuoteListStatus {}

class QuoteListLoadedStatus extends QuoteListStatus {
  final List<QuoteModel> list;
  final bool hasReachedMax;

  QuoteListLoadedStatus(this.list, {this.hasReachedMax = false});
}

class QuoteListErrorStatus extends QuoteListStatus {
  final Failure failure;
  QuoteListErrorStatus(this.failure);
}

class QuoteListLoadedMoreErrorStatus extends QuoteListStatus {
  QuoteListLoadedMoreErrorStatus();
}