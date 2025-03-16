class QuoteDto {
  QuoteDto({
    String? id,
    String? content,
    String? author
  }) {
    _id = id;
    _author = author;
    _content = content;
  }

  QuoteDto.fromJson(dynamic json) {
    _id = json["_id"];
    _author = json['author'];
    _content = json['content'];
  }

  String? _id;
  String? _author;
  String? _content;

  QuoteDto copyWith({
    String? id,
    String? author,
    String? content,
  }) =>
      QuoteDto(
        id: id ?? _id,
        author: author ?? _author,
        content: content ?? _content,
      );

  String? get author => _author;

  String? get id => _id;

  String? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['author'] = _author;
    map['content'] = _content;
    return map;
  }
}
