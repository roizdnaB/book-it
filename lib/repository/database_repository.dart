import 'package:book_it/network_provider/database_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/book.dart';

class DatabaseRepository {
  final DatabaseProvider provider;

  DatabaseRepository({this.provider});

  Future<void> addItem(Book book) => provider.addItem(book: book);

  Future<void> editItem(final book, final docId) =>
      provider.editItem(book, docId);

  Future<void> deleteItem(final docId) => provider.deleteItem(docId);

  Stream<QuerySnapshot> readItems() => provider.readItems();

  Stream<QuerySnapshot> readReadItems() => provider.readReadItems();

  Stream<QuerySnapshot> readUnreadItems() => provider.readUnreadItems();

  String getUserUid() => provider.getUserUid();
}
