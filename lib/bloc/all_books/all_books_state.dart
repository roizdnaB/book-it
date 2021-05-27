import 'package:equatable/equatable.dart';

abstract class AllBooksState extends Equatable {
  @override
  List<Object> get props => [];
}

class AllBooksInitial extends AllBooksState {}

class AllBooksSuccess extends AllBooksState {
  final books;
  final String userUid;

  AllBooksSuccess({this.books, this.userUid});

  @override
  List<Object> get props => [books, userUid];
}

class AllBooksFailure extends AllBooksState {}

class AllBooksLoading extends AllBooksState {}
