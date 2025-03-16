part of 'quote_list_bloc.dart';

@immutable
abstract class QuoteListEvent {}

class GetQuoteListEvent extends QuoteListEvent {
  final bool isRefresh;

  GetQuoteListEvent({this.isRefresh = false});
}

class LoadMoreQuotes extends QuoteListEvent {}

class PageToInitial extends QuoteListEvent {}