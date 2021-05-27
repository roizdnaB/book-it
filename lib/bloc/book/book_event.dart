import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddBook extends BookEvent {
  final title;
  final author;
  final shortDescription;
  final isRead;

  AddBook({this.title, this.author, this.shortDescription, this.isRead});
}

class EditBook extends BookEvent {
  final title;
  final author;
  final shortDescription;
  final isRead;
  final docId;

  EditBook(
      {this.title,
      this.author,
      this.shortDescription,
      this.isRead,
      this.docId});
}

class DeleteBook extends BookEvent {
  final docId;

  DeleteBook({this.docId});
}

class BookSettoInitial extends BookEvent {}
