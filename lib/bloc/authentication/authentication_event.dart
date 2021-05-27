import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignedIn extends AuthenticationEvent {
  final String email;
  final String password;

  SignedIn({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}

class SignedOut extends AuthenticationEvent {}
