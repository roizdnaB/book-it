import 'package:book_it/repository/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseProvider {
  final String userUid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference _mainCollection;

  DatabaseProvider({this.userUid}) {
    _mainCollection = firestore.collection('books');
  }

  Future<void> addItem({Book book}) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc();

    await documentReferencer
        .set(book.toMap())
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  Future<void> editItem(final book, final docId) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .update(book.toMap())
        .then((value) => print('Book Updated'))
        .catchError((error) => print('Failed to updated'));
  }

  Future<void> deleteItem(final docId) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Deleted'))
        .catchError((error) => print(error));
  }

  Stream<QuerySnapshot> readItems() {
    final response =
        _mainCollection.doc(userUid).collection('items').snapshots();
    return response;
  }

  Stream<QuerySnapshot> readReadItems() {
    final response = _mainCollection.doc(userUid).collection('items');
    Query readBooks = response.where('isRead', isEqualTo: true);

    return readBooks.snapshots();
  }

  Stream<QuerySnapshot> readUnreadItems() {
    final response = _mainCollection.doc(userUid).collection('items');
    Query unreadBooks = response.where('isRead', isEqualTo: false);

    return unreadBooks.snapshots();
  }

  String getUserUid() => userUid;
}
