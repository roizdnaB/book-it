import 'package:book_it/network_provider/firestore_provider.dart';

class FirestoreRepository {
  final FirestoreProvider _provider = FirestoreProvider();

  Future<void> signInWithEmailAndPassword(String email, String password) =>
      _provider.signInWithEmailAndPassword(email, password);

  Future<void> signOut() => _provider.signOut();

  Future<void> signUp(String email, String password) =>
      _provider.signUp(email, password);

  String getUserUid() => _provider.getUserUid();
}
