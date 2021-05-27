import 'package:book_it/bloc/sign_up/sign_up_bloc.dart';
import 'package:book_it/bloc/sign_up/sign_up_event.dart';
import 'package:book_it/bloc/sign_up/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          if (state is SignUpInitial) {
            return SignUpInitialView();
          } else if (state is SignUpInProgress) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is SignUpSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('User created')));
            });
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return Container();
          } else if (state is SignUpFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Something went wrong')));
            });
            BlocProvider.of<SignUpBloc>(context).add(Reset());
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class SignUpInitialView extends StatefulWidget {
  @override
  _SignUpInitialViewState createState() => _SignUpInitialViewState();
}

class _SignUpInitialViewState extends State<SignUpInitialView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SignUpBloc>(context).add(Reset());

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextFormField(
                  controller: passwordController,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the password';
                    } else if (value.length <= 5) {
                      return 'Password should have 6 or more characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    BlocProvider.of<SignUpBloc>(context).add(SignedUp(
                        email: emailController.text,
                        password: passwordController.text));
                  }
                },
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
