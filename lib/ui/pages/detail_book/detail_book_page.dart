import 'package:book_it/repository/models/book.dart';
import 'package:flutter/material.dart';

class DetailBookPage extends StatelessWidget {
  final Book book;

  DetailBookPage({this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Image(
                  image: AssetImage('assets/book.png'),
                ),
              ),
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                book.author,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(book.shortDescription),
              ),
              SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.5,
                child: getMessage(book.isRead),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Text getMessage(bool isRead) {
  if (isRead) {
    return Text("You've read this book");
  } else {
    return Text("You've not read this book");
  }
}
