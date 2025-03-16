import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes/core/error_handling/failure.dart';
import 'package:quotes/core/theme/theme_manager.dart';
import 'package:quotes/core/widget/circular_progress_bar_widget.dart';
import 'package:quotes/core/widget/error_handling/error_handling_factory_widget.dart';
import 'package:quotes/core/widget/non_scrollable_refresh_indicator_widget.dart';
import 'package:quotes/features/quote_list/domain/model/quote_model.dart';
import 'package:quotes/features/quote_list/presentation/bloc/quote_list_bloc.dart';
import 'package:quotes/features/quote_list/presentation/bloc/quote_list_status.dart';
import 'package:quotes/features/quote_list/presentation/widget/quote_item_widget.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> with AutomaticKeepAliveClientMixin<QuotesScreen> {
  final ScrollController _scrollController = ScrollController();
  late AppColor _appColor;
  DateTime _lastScrollTime = DateTime.now(); // Add this to track scroll time
  DateTime _lastRefreshTime = DateTime.now().subtract(const Duration(seconds: 1));
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  void _initScreen() {
    // Load data immediately
    _loadInitialData();

    // Setup scroll controller
    _scrollController.addListener(() {
      _checkScrollPosition();
    });
  }

  // MARK: - Data Loading

  void _loadInitialData() {
    // Debounce refresh operations
    final now = DateTime.now();
    if (_isRefreshing || now.difference(_lastRefreshTime).inMilliseconds < 500) {
      print('⏳ Skipping refresh - already in progress or too soon');
      return;
    }
    
    _isRefreshing = true;
    _lastRefreshTime = now;
    
    print('🔄 Loading initial data...');
    final bloc = _getBloc();
    // Reset any error flags
    if (bloc is QuoteListBloc) {
      bloc.resetLoadMoreError();
    }
    bloc.add(GetQuoteListEvent(isRefresh: true));
    
    // Reset refresh flag after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _isRefreshing = false;
    });
  }

  void _loadMoreData() {
    print('📥 Attempting to load more data...');
    final state = _getBloc().state;
    if (state is GetQuoteListState) {
      final status = state.quotesListStatus;

      // More verbose debugging
      if (status is QuoteListLoadingStatus) {
        print('⏳ Cannot load more: Already in loading status');
        return;
      }
      if (status is QuoteListLoadingMoreStatus) {
        print('⏳ Cannot load more: Already loading more');
        return;
      }
      if (status is QuoteListLoadedStatus && status.hasReachedMax) {
        print('🛑 Cannot load more: Reached maximum');
        return;
      }

      print('✅ Sending load more event to bloc');
      _getBloc().add(GetQuoteListEvent(isRefresh: false));
    } else {
      print('❌ Cannot load more: State is not GetQuoteListState');
    }
  }

  // MARK: - Scroll Handling

  void _checkScrollPosition() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final timeSinceLastScroll = now.difference(_lastScrollTime);
    
    // Debounce scroll events - only process if it's been at least 500ms since last scroll
    if (timeSinceLastScroll.inMilliseconds < 500) {
      return;
    }
    
    _lastScrollTime = now;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.8; // Load more when 80% scrolled

    print('📜 Scroll position: $currentScroll / $maxScroll (threshold: $threshold)');

    if (currentScroll >= threshold) {
      print('🔍 Threshold reached, trying to load more...');
      _loadMoreData();
    }
  }

  // MARK: - Helpers

  QuoteListBloc _getBloc() => BlocProvider.of<QuoteListBloc>(context);

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Helper method to get quotes from state
  List<QuoteModel> _getQuotes(QuoteListState state) {
    if (state is GetQuoteListState) {
      final status = state.quotesListStatus;
      if (status is QuoteListLoadedStatus) {
        return status.list;
      } else if (status is QuoteListLoadingMoreStatus) {
        return status.currentItems;
      }
    }
    return [];
  }

  // MARK: - Widget Building

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _appColor = Theme.of(context).extension<AppColor>()!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: _appColor.primaryColor,
      ),
      body: BlocConsumer<QuoteListBloc, QuoteListState>(
        listenWhen: (previous, current) {
          // Only listen when we need to show errors
          if (current is GetQuoteListState && previous is GetQuoteListState) {
            return current.quotesListStatus is QuoteListErrorStatus || 
                   current.quotesListStatus is QuoteListLoadedMoreErrorStatus;
          }
          return true;
        },
        buildWhen: (previous, current) {
          // Don't rebuild for loading more states
          if (current is GetQuoteListState && previous is GetQuoteListState) {
            final prevStatus = previous.quotesListStatus;
            final currStatus = current.quotesListStatus;
            
            // If we're just transitioning from loading more to loaded, keep previous build
            if (prevStatus is QuoteListLoadingMoreStatus && 
                currStatus is QuoteListLoadedStatus) {
              return true; // Let it rebuild with new data
            }
          }
          return true;
        },
        listener: (context, state) {
          if (state is GetQuoteListState) {
            final status = state.quotesListStatus;
            final quotes = _getQuotes(state);

            print('👂 State listener: status=${status.runtimeType}, quotes length=${quotes.length}');

            if (status is QuoteListErrorStatus &&
                !(status is QuoteListEmptyStatus) &&
                quotes.isNotEmpty) {
              _showErrorSnackBar('Error loading quotes: ${status.failure}');
            }
          }
        },
        builder: (context, state) {
          if (state is! GetQuoteListState) {
            return const SizedBox.shrink();
          }

          final status = state.quotesListStatus;
          List<QuoteModel> quotes = [];
          
          // Extract quotes based on status
          if (status is QuoteListLoadedStatus) {
            quotes = status.list;
          } else if (status is QuoteListLoadingMoreStatus) {
            quotes = status.currentItems;  // Use existing items while loading more
          }

          print('🏗️ Building UI: status=${status.runtimeType}, quotes length=${quotes.length}');

          // Initial loading state
          if (status is QuoteListLoadingStatus && quotes.isEmpty) {
            print('🔄 Showing initial loading indicator');
            return _buildLoadingIndicator();
          }

          // Empty state
          if (quotes.isEmpty || status is QuoteListEmptyStatus) {
            print('📭 Showing empty state');
            return _buildErrorWidget(Failure.noFoundData);
          }

          // Error state for initial load
          if (status is QuoteListErrorStatus && quotes.isEmpty) {
            print('❌ Showing error state');
            return _buildErrorWidget(status.failure);
          }

          // Determine if we're loading more
          final bool isLoadingMore = status is QuoteListLoadingMoreStatus;

          // Determine if we can load more
          final bool canLoadMore = status is QuoteListLoadedStatus ?
          !status.hasReachedMax : true;

          print('📊 List state: isLoadingMore=$isLoadingMore, canLoadMore=$canLoadMore');

          // Show list with quotes
          return _buildQuotesList(quotes, isLoadingMore, canLoadMore);
        },
      ),
    );
  }

  // MARK: - UI Components

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressBarWidget(color: _appColor.primaryColor),
    );
  }

  Widget _buildErrorWidget(Failure failure) {
    return NonScrollableRefreshIndicatorWidget(
      onRefresh: () async => _loadInitialData(),
      child: ErrorHandlingFactoryWidget(
        context,
        failure,
        onClickListener: _loadInitialData,
      ),
    );
  }

  Widget _buildQuotesList(List<QuoteModel> quotes, bool isLoadingMore, bool canLoadMore) {
    print('📋 Building list: ${quotes.length} quotes, isLoadingMore=$isLoadingMore, canLoadMore=$canLoadMore');

    final shouldShowFooter = canLoadMore;

    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Check if we're already refreshing
                if (_isRefreshing) {
                  print('⏳ Refresh already in progress');
                  // This delay is needed to satisfy the RefreshIndicator
                  await Future.delayed(const Duration(milliseconds: 500)); 
                  return;
                }
                
                _loadInitialData();
                // Wait for animation to complete
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                key: const PageStorageKey<String>('quotes_list'),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: quotes.length + (shouldShowFooter ? 1 : 0),
                itemBuilder: (context, index) {
                  // Show loading indicator or "Load More" button at the bottom
                  if (index == quotes.length && shouldShowFooter) {
                    print('🦶 Showing footer at index $index (isLoadingMore=$isLoadingMore)');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: isLoadingMore
                            ? CircularProgressBarWidget(color: _appColor.primaryColor)
                            : ElevatedButton(
                          onPressed: _loadMoreData,
                          child: const Text('Load More'),
                        ),
                      ),
                    );
                  }

                  // Regular quote item
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: QuoteItemWidget(
                      id: quotes[index].id,
                      content: quotes[index].content,
                      author: quotes[index].author,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }
}