import 'package:book_it/repository/database_repository.dart';
import 'package:book_it/repository/models/book.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final DatabaseRepository repository;

  BookBloc({this.repository}) : super(BookInitial());

  @override
  Stream<BookState> mapEventToState(BookEvent event) async* {
    if (event is AddBook) {
      yield BookLoading();

      try {
        await repository.addItem(Book(
            title: event.title,
            author: event.author,
            shortDescription: event.shortDescription,
            isRead: event.isRead));

        yield BookSuccess();
      } catch (Exception) {
        yield BookFailure();
      }
    } else if (event is EditBook) {
      yield BookLoading();

      try {
        await repository.editItem(
            Book(
                title: event.title,
                author: event.author,
                shortDescription: event.shortDescription,
                isRead: event.isRead),
            event.docId);

        yield BookSuccess();
      } catch (Exception) {
        yield BookFailure();
      }
    } else if (event is DeleteBook) {
      yield BookLoading();

      try {
        await repository.deleteItem(event.docId);

        yield BookSuccess();
      } catch (Exception) {
        yield BookFailure();
      }
    }
  }
}
