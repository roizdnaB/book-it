import 'package:equatable/equatable.dart';

abstract class AllBooksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AllBooksFetched extends AllBooksEvent {}

class AllBooksReadBooksFetched extends AllBooksEvent {}

class AllBooksSettoInitial extends AllBooksEvent {}

class AllBooksUnreadBooksFetched extends AllBooksEvent {}

class AllBooksEdit extends AllBooksEvent {
  final book;
  final docId;

  AllBooksEdit({this.book, this.docId});

  @override
  List<Object> get props => [book, docId];
}
