part of 'quote_list_bloc.dart';

abstract class QuoteListState {}

class InitialState extends QuoteListState {}

class GetQuoteListState extends QuoteListState {
  final QuoteListStatus quotesListStatus;
  GetQuoteListState(this.quotesListStatus);
}