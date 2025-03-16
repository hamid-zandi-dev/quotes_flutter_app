class QuoteModel {
  
  final String id;
  final String content;
  final String author;

  QuoteModel({
    this.id = '',
    this.author = '',
    required this.content
  });
}