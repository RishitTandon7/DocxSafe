import 'document.dart';

class Folder {
  final String id;
  final String name;
  final List<Document> documents;
  final List<Folder> subfolders;

  Folder({
    required this.id,
    required this.name,
    this.documents = const [],
    this.subfolders = const [],
  });
}
