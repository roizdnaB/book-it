import 'package:book_it/bloc/all_books/all_books_bloc.dart';
import 'package:book_it/bloc/all_books/all_books_event.dart';
import 'package:book_it/bloc/all_books/all_books_state.dart';
import 'package:book_it/bloc/authentication/authentication_bloc.dart';
import 'package:book_it/bloc/authentication/authentication_event.dart';
import 'package:book_it/bloc/authentication/authentication_state.dart';
import 'package:book_it/network_provider/database_provider.dart';
import 'package:book_it/repository/database_repository.dart';
import 'package:book_it/repository/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final String userUid;

  HomePage({this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Book It'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sign Out',
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(SignedOut());
              },
            )
          ],
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<AllBooksBloc>(
                create: (context) => AllBooksBloc(
                    repository: DatabaseRepository(
                        provider: DatabaseProvider(userUid: userUid)))),
          ],
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationSuccess) {
                return HomeSuccess(uid: state.userUid);
              } else if (state is AuthenticationInProgress) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is AuthenticationInitial) {
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

class HomeSuccess extends StatefulWidget {
  final uid;

  HomeSuccess({this.uid});

  @override
  _HomeSuccessState createState() => _HomeSuccessState(uid: uid);
}

class _HomeSuccessState extends State<HomeSuccess> {
  final uid;

  _HomeSuccessState({this.uid});

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    AllBooksPage(),
    ReadBooksPage(),
    UnreadBooksPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'All Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Read Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Unread Books',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushNamed('/add_book', arguments: DataForEdit(userUid: uid));
          });
          BlocProvider.of<AllBooksBloc>(context).add(AllBooksFetched());
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}

class AllBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AllBooksBloc>(context).add(AllBooksFetched());

    return Scaffold(
      body: BlocBuilder<AllBooksBloc, AllBooksState>(builder: (context, state) {
        if (state is AllBooksInitial) {
          BlocProvider.of<AllBooksBloc>(context).add(AllBooksFetched());
          return Container();
        } else if (state is AllBooksSuccess) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.books,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text('Empty'),
                );
              } else {
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new ListTile(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/detail_book',
                              arguments: Book.fromMap(document.data()));
                        });
                      },
                      onLongPress: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/add_book',
                              arguments: DataForEdit(
                                  userUid: state.userUid,
                                  book: Book.fromMap(document.data()),
                                  docId: document.id));
                        });
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(document.data()['title']),
                          IconButton(
                              onPressed: () {
                                final newBook = Book.fromMap(document.data());
                                newBook.isRead = !newBook.isRead;
                                BlocProvider.of<AllBooksBloc>(context).add(
                                    AllBooksEdit(
                                        book: newBook, docId: document.id));
                                BlocProvider.of<AllBooksBloc>(context)
                                    .add(AllBooksSettoInitial());
                              },
                              icon: Icon(
                                  getIsReadIcon(document.data()['isRead']))),
                        ],
                      ),
                      subtitle: new Text(document.data()['author']),
                    );
                  }).toList(),
                );
              }
            },
          );
        } else if (state is AllBooksFailure) {
          return Container();
        } else if (state is AllBooksLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class ReadBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AllBooksBloc>(context).add(AllBooksReadBooksFetched());

    return Scaffold(
      body: BlocBuilder<AllBooksBloc, AllBooksState>(builder: (context, state) {
        if (state is AllBooksInitial) {
          BlocProvider.of<AllBooksBloc>(context)
              .add(AllBooksReadBooksFetched());
          return Container();
        } else if (state is AllBooksSuccess) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.books,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text('Empty'),
                );
              } else {
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new ListTile(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/detail_book',
                              arguments: Book.fromMap(document.data()));
                        });
                      },
                      onLongPress: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/add_book',
                              arguments: DataForEdit(
                                  userUid: state.userUid,
                                  book: Book.fromMap(document.data()),
                                  docId: document.id));
                        });
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(document.data()['title']),
                          IconButton(
                              onPressed: () {
                                final newBook = Book.fromMap(document.data());
                                newBook.isRead = !newBook.isRead;
                                BlocProvider.of<AllBooksBloc>(context).add(
                                    AllBooksEdit(
                                        book: newBook, docId: document.id));
                                BlocProvider.of<AllBooksBloc>(context)
                                    .add(AllBooksSettoInitial());
                              },
                              icon: Icon(
                                  getIsReadIcon(document.data()['isRead']))),
                        ],
                      ),
                      subtitle: new Text(document.data()['author']),
                    );
                  }).toList(),
                );
              }
            },
          );
        } else if (state is AllBooksFailure) {
          return Container();
        } else if (state is AllBooksLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class UnreadBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AllBooksBloc>(context).add(AllBooksUnreadBooksFetched());

    return Scaffold(
      body: BlocBuilder<AllBooksBloc, AllBooksState>(builder: (context, state) {
        if (state is AllBooksInitial) {
          BlocProvider.of<AllBooksBloc>(context)
              .add(AllBooksUnreadBooksFetched());
          return Container();
        } else if (state is AllBooksSuccess) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.books,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Text('Empty'),
                );
              } else {
                return new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new ListTile(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/detail_book',
                              arguments: Book.fromMap(document.data()));
                        });
                      },
                      onLongPress: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).pushNamed('/add_book',
                              arguments: DataForEdit(
                                  userUid: state.userUid,
                                  book: Book.fromMap(document.data()),
                                  docId: document.id));
                        });
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(document.data()['title']),
                          IconButton(
                              onPressed: () {
                                final newBook = Book.fromMap(document.data());
                                newBook.isRead = !newBook.isRead;
                                BlocProvider.of<AllBooksBloc>(context).add(
                                    AllBooksEdit(
                                        book: newBook, docId: document.id));
                                BlocProvider.of<AllBooksBloc>(context)
                                    .add(AllBooksSettoInitial());
                              },
                              icon: Icon(
                                  getIsReadIcon(document.data()['isRead']))),
                        ],
                      ),
                      subtitle: new Text(document.data()['author']),
                    );
                  }).toList(),
                );
              }
            },
          );
        } else if (state is AllBooksFailure) {
          return Container();
        } else if (state is AllBooksLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

IconData getIsReadIcon(bool isRead) {
  if (isRead) {
    return Icons.bookmark;
  } else {
    return Icons.bookmark_border;
  }
}

class DataForEdit {
  final userUid;
  final Book book;
  final docId;

  DataForEdit({this.userUid, this.book, this.docId});
}
