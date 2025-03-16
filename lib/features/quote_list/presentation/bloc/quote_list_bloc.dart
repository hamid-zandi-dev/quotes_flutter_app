import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/features/quote_list/domain/model/quote_model.dart';
import 'package:quotes/features/quote_list/domain/model/quotes_model.dart';
import 'package:quotes/features/quote_list/domain/use_case/get_quotes_use_case.dart';
import 'package:quotes/features/quote_list/presentation/bloc/quote_list_status.dart';

part 'quote_list_event.dart';
part 'quote_list_state.dart';

class QuoteListBloc extends Bloc<QuoteListEvent, QuoteListState> {
  final GetQuotesUseCase _getQuotesUseCase;
  final List<QuoteModel> _quotesModel = [];
  int _pageNumber = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasLoadMoreError = false;
  final Set<int> _requestingPages = {};
  bool _isRefreshing = false;

  QuoteListBloc(this._getQuotesUseCase) : super(InitialState()) {
    on<PageToInitial>((event, emit) => _handlePageToInitial(emit));
    on<GetQuoteListEvent>((event, emit) => _handleGetQuoteListEvent(event, emit));
  }

  void _handlePageToInitial(Emitter<QuoteListState> emit) {
    _quotesModel.clear();
    _pageNumber = 1;
    _totalPages = 1;
    _isLoading = false;
    emit(InitialState());
  }

  Future<void> _handleGetQuoteListEvent(GetQuoteListEvent event, Emitter<QuoteListState> emit) async {
    // Debug logs
    print('📑 Loading quotes: page=$_pageNumber, totalPages=$_totalPages, isRefresh=${event.isRefresh}');
    
    // For refresh operations
    if (event.isRefresh) {
      // Don't allow concurrent refresh operations
      if (_isRefreshing) {
        print('⚠️ Skip refresh - already refreshing');
        return;
      }
      _isRefreshing = true;
      
      // Reset flags for fresh start
      _hasLoadMoreError = false;
      _requestingPages.clear();
    }
    
    // Don't proceed if we're already loading this specific page
    if (_requestingPages.contains(_pageNumber)) {
      print('⚠️ Skip loading - page $_pageNumber already being requested');
      return;
    }
    
    // Don't proceed if we're already loading
    if (_isLoading) {
      print('⚠️ Skip loading - already in progress');
      return;
    }
    
    // Don't proceed if we've had an error and this is not a refresh
    if (!event.isRefresh && _hasLoadMoreError) {
      print('⚠️ Skip loading - previous error not cleared');
      return;
    }

    // Don't proceed if we've reached the end and this is not a refresh
    if (!event.isRefresh && _pageNumber > _totalPages) {
      print('⚠️ Skip loading - reached max pages');
      emit(GetQuoteListState(QuoteListLoadedStatus(
        List.from(_quotesModel),
        hasReachedMax: true,
      )));
      return;
    }

    _isLoading = true;
    _requestingPages.add(_pageNumber); // Mark this page as being requested
    
    // Reset pagination if this is a refresh
    if (event.isRefresh) {
      _quotesModel.clear();  // Only clear the list if this is a refresh!
      _pageNumber = 1;       // Only reset page if this is a refresh!
      emit(GetQuoteListState(QuoteListLoadingStatus()));
    } else if (_quotesModel.isNotEmpty) {
      // For loading more, keep existing items in the state
      emit(GetQuoteListState(QuoteListLoadingMoreStatus(List.from(_quotesModel))));
    } else {
      // Initial loading
      emit(GetQuoteListState(QuoteListLoadingStatus()));
    }

    try {
      final result = await _getQuotesUseCase(
        GetQuotesParams.forQuery(page: _pageNumber),
      );

      result.fold(
        (failure) {
          _isLoading = false;
          if (!event.isRefresh) {
            _hasLoadMoreError = true;
          }
          if (_quotesModel.isEmpty) {
            emit(GetQuoteListState(QuoteListErrorStatus(failure)));
          } else {
            // If we already have items, just show error for loading more
            emit(GetQuoteListState(QuoteListLoadedMoreErrorStatus()));
            // Then revert to loaded state with existing items
            emit(GetQuoteListState(QuoteListLoadedStatus(_quotesModel, hasReachedMax: _pageNumber >= _totalPages)));
          }
        },
        (success) {
          _isLoading = false;
          final state = _handleSuccessResponse(success);
          emit(state);
        },
      );
    } catch (e) {
      _isLoading = false;
      if (!event.isRefresh) {
        _hasLoadMoreError = true;
      }
      print('❌ Error loading quotes: $e');
      if (_quotesModel.isEmpty) {
        emit(GetQuoteListState(QuoteListErrorStatus(Failure.serverError)));
      } else {
        // Keep existing items if we have them
        emit(GetQuoteListState(QuoteListLoadedStatus(_quotesModel, hasReachedMax: false)));
      }
    } finally {
      _isLoading = false;
      _requestingPages.remove(_pageNumber);
      if (event.isRefresh) {
        _isRefreshing = false;
      }
    }
  }

  GetQuoteListState _handleSuccessResponse(QuotesModel quotesModel) {
    // Debug logs
    print('📥 Received quotes: count=${quotesModel.results.length}, currentPage=$_pageNumber, totalPages=${quotesModel.totalPages}');
    
    // Store the total pages from the response
    _totalPages = quotesModel.totalPages.toInt();

    // Add new items to our list if there are any
    if (quotesModel.results.isNotEmpty) {
      _quotesModel.addAll(quotesModel.results);
      // Increment page number only if we got results
      _pageNumber++;
      print('📈 Updated state: totalItems=${_quotesModel.length}, nextPage=$_pageNumber');
    }

    if (_quotesModel.isEmpty) {
      return GetQuoteListState(QuoteListEmptyStatus());
    } else {
      // Check if we've reached max
      bool hasReachedMax = _pageNumber > _totalPages || quotesModel.results.isEmpty;
      return GetQuoteListState(QuoteListLoadedStatus(
          List.from(_quotesModel), // Return a copy to ensure UI updates
          hasReachedMax: hasReachedMax
      ));
    }
  }

  void resetLoadMoreError() {
    _hasLoadMoreError = false;
  }
}