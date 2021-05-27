import 'package:book_it/repository/database_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'all_books_event.dart';
import 'all_books_state.dart';

class AllBooksBloc extends Bloc<AllBooksEvent, AllBooksState> {
  final DatabaseRepository repository;

  AllBooksBloc({this.repository}) : super(AllBooksInitial());

  @override
  Stream<AllBooksState> mapEventToState(AllBooksEvent event) async* {
    if (event is AllBooksFetched) {
      yield AllBooksLoading();
      final books = repository.readItems();

      yield AllBooksSuccess(books: books, userUid: repository.getUserUid());
    } else if (event is AllBooksReadBooksFetched) {
      yield AllBooksLoading();
      final books = repository.readReadItems();
      yield AllBooksSuccess(books: books);
    } else if (event is AllBooksSettoInitial) {
      yield AllBooksInitial();
    } else if (event is AllBooksUnreadBooksFetched) {
      yield AllBooksLoading();
      final books = repository.readUnreadItems();

      yield AllBooksSuccess(books: books, userUid: repository.getUserUid());
    } else if (event is AllBooksEdit) {
      yield AllBooksLoading();
      repository.editItem(event.book, event.docId);

      yield AllBooksSuccess();
    }
  }
}
