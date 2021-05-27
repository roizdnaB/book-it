import 'package:book_it/bloc/authentication/authentication_bloc.dart';
import 'package:book_it/bloc/sign_up/sign_up_bloc.dart';
import 'package:book_it/repository/firestore_repository.dart';
import 'package:book_it/ui/pages/add_book/add_book_page.dart';
import 'package:book_it/ui/pages/detail_book/detail_book_page.dart';
import 'package:book_it/ui/pages/home/home_page.dart';
import 'package:book_it/ui/pages/sign_in/sign_in_page.dart';
import 'package:book_it/ui/pages/sign_up/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final repo = FirestoreRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(repository: repo),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(repository: repo),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book It',
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(),
        '/home': (context) => HomePage(),
        '/sign_up': (context) => SignUpPage(),
        '/add_book': (context) =>
            AddBookPage(ModalRoute.of(context).settings.arguments),
        '/detail_book': (context) =>
            DetailBookPage(book: ModalRoute.of(context).settings.arguments),
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffbf360c),
        accentColor: Color(0xff5c6bc0),
        fontFamily: 'Georgia',
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Color(0xff5c6bc0),
          ),
        ),
      ),
    );
  }
}
