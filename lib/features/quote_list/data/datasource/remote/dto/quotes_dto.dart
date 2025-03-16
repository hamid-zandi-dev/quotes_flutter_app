import 'quote_dto.dart';

class QuotesDto {
  QuotesDto({
    String? status,
    num? count,
    num? totalCount,
    num? page,
    num? totalPages,
    num? lastItemIndex,
    List<QuoteDto>? results,
  }) {
    _status = status;
    _count = count;
    _totalCount = totalCount;
    _page = page;
    _totalPages = totalPages;
    _lastItemIndex = lastItemIndex;
    _results = results;
  }

  QuotesDto.fromJson(dynamic json) {
    _status = json['status'];
    _count = json['count'];
    _totalCount = json['totalCount'];
    _page = json['page'];
    _totalPages = json['totalPages'];
    _lastItemIndex = json['lastItemIndex'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(QuoteDto.fromJson(v));
      });
    }
  }

  String? _status;
  num? _count;
  num? _totalCount;
  num? _page;
  num? _totalPages;
  num? _lastItemIndex;
  List<QuoteDto>? _results;

  QuotesDto copyWith({
    String? status,
    num? count,
    num? totalCount,
    num? page,
    num? totalPages,
    num? lastItemIndex,
    List<QuoteDto>? results,
  }) =>
      QuotesDto(
        status: status ?? _status,
        count: count ?? _count,
        totalCount: totalCount ?? _totalCount,
        page: page ?? _page,
        totalPages: totalPages ?? _totalPages,
        lastItemIndex: lastItemIndex ?? _lastItemIndex,
        results: results ?? _results,
      );

  String? get status => _status;
  num? get count => _count;
  num? get totalCount => _totalCount;
  num? get page => _page;
  num? get totalPages => _totalPages;
  num? get lastItemIndex => _lastItemIndex;
  List<QuoteDto>? get results => _results;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['count'] = _count;
    map['totalCount'] = _totalCount;
    map['page'] = _page;
    map['totalPages'] = _totalPages;
    map['lastItemIndex'] = _lastItemIndex;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
