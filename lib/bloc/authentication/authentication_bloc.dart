import 'package:book_it/repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirestoreRepository repository;

  AuthenticationBloc({this.repository}) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is SignedIn) {
      yield* mapSignedInToState(event);
    } else if (event is SignedOut) {
      yield* mapSignedOutToState(event);
    }
  }

  Stream<AuthenticationState> mapSignedInToState(SignedIn event) async* {
    try {
      yield AuthenticationInProgress();
      await repository.signInWithEmailAndPassword(event.email, event.password);
      yield AuthenticationSuccess(userUid: repository.getUserUid());
    } catch (_) {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> mapSignedOutToState(SignedOut event) async* {
    try {
      yield AuthenticationInProgress();
      await repository.signOut();
      yield AuthenticationInitial();
    } catch (_) {
      yield AuthenticationFailure();
    }
  }
}
