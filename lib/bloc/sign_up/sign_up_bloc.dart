import 'package:book_it/bloc/sign_up/sign_up_event.dart';
import 'package:book_it/bloc/sign_up/sign_up_state.dart';
import 'package:book_it/repository/firestore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirestoreRepository repository;

  SignUpBloc({this.repository}) : super(SignUpInitial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignedUp) {
      yield* mapSignedUpToState(event);
    } else if (event is Reset) {
      yield SignUpInitial();
    }
  }

  Stream<SignUpState> mapSignedUpToState(SignedUp event) async* {
    try {
      yield SignUpInProgress();
      await repository.signUp(event.email, event.password);
      yield SignUpSuccess();
      await Future.delayed(const Duration(milliseconds: 500), () {});
      yield SignUpInitial();
    } catch (_) {
      yield SignUpFailure();
    }
  }
}
