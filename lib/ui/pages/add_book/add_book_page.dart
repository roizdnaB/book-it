import 'package:book_it/bloc/book/book_bloc.dart';
import 'package:book_it/bloc/book/book_event.dart';
import 'package:book_it/bloc/book/book_state.dart';
import 'package:book_it/network_provider/database_provider.dart';
import 'package:book_it/repository/database_repository.dart';
import 'package:book_it/repository/models/book.dart';
import 'package:book_it/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookPage extends StatefulWidget {
  final DataForEdit data;

  AddBookPage(this.data);

  @override
  _AddBookPageState createState() =>
      _AddBookPageState(data.userUid, book: data.book, docId: data.docId);
}

class _AddBookPageState extends State<AddBookPage> {
  final userId;
  final Book book;
  final docId;

  _AddBookPageState(this.userId, {this.book, this.docId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<BookBloc>(
              create: (context) => BookBloc(
                  repository: DatabaseRepository(
                      provider: DatabaseProvider(userUid: userId)))),
        ],
        child: Scaffold(
          appBar: AppBar(title: prepareTitle(book)),
          body: BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookInitial) {
                return BookInitialView(book: book, docId: docId);
              } else if (state is BookLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is BookSuccess) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
                return Container();
              } else if (state is BookFailure) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pop();
                });
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ));
  }
}

class BookInitialView extends StatefulWidget {
  final docId;
  final Book book;

  BookInitialView({this.book, this.docId});

  @override
  _BookInitialViewState createState() =>
      _BookInitialViewState(docId: docId, book: book);
}

class _BookInitialViewState extends State<BookInitialView> {
  final docId;
  final Book book;

  _BookInitialViewState({this.docId, this.book});

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final shortDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isRead = true;
  String dropdownValue = 'Yes';

  @override
  Widget build(BuildContext context) {
    prepareControllers(
        titleController, authorController, shortDescriptionController, book);

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: authorController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'Author'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: shortDescriptionController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Short Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the short description';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Have you read it?'),
                SizedBox(width: 30),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      if (dropdownValue == 'Yes') {
                        isRead = true;
                      } else {
                        isRead = false;
                      }
                    });
                  },
                  items: <String>['Yes', 'No']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (book != null) {
                    BlocProvider.of<BookBloc>(context).add(EditBook(
                        title: titleController.text,
                        author: authorController.text,
                        shortDescription: shortDescriptionController.text,
                        isRead: isRead,
                        docId: docId));
                  } else {
                    BlocProvider.of<BookBloc>(context).add(AddBook(
                        title: titleController.text,
                        author: authorController.text,
                        shortDescription: shortDescriptionController.text,
                        isRead: isRead));
                  }
                }
              },
              child: prepareButtonLabel(book),
            ),
            deleteButton(book, docId, context),
          ],
        ),
      ),
    );
  }
}

void prepareControllers(
    TextEditingController title,
    TextEditingController author,
    TextEditingController description,
    Book book) {
  if (book != null) {
    title.text = book.title;
    author.text = book.author;
    description.text = book.shortDescription;
  }
}

Text prepareTitle(Book book) {
  if (book != null) {
    return Text(book.title);
  } else {
    return Text('Add book to Book It!');
  }
}

Text prepareButtonLabel(Book book) {
  if (book != null) {
    return Text('Edit the book');
  } else {
    return Text('Add the book');
  }
}

Widget deleteButton(Book book, final docId, final context) {
  if (book != null) {
    return TextButton(
        onPressed: () {
          BlocProvider.of<BookBloc>(context).add(DeleteBook(docId: docId));
        },
        child: Text('Delete the book'));
  } else {
    return Container();
  }
}
