import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookSuccess extends BookState {}

class BookFailure extends BookState {}

class BookLoading extends BookState {}
