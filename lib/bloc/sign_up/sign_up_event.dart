import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignedUp extends SignUpEvent {
  final String email;
  final String password;

  SignedUp({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class Reset extends SignUpEvent {}
