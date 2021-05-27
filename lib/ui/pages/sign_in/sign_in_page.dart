import 'package:book_it/bloc/authentication/authentication_bloc.dart';
import 'package:book_it/bloc/authentication/authentication_event.dart';
import 'package:book_it/bloc/authentication/authentication_state.dart';
import 'package:book_it/ui/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In to Book It!'),
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return SignInInitial();
          } else if (state is AuthenticationInProgress) {
            return SignInInProgress();
          } else if (state is AuthenticationSuccess) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(userUid: state.userUid)));
            });
            return Container();
          } else if (state is AuthenticationFailure) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid email or password')));
            });
            return SignInInitial();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class SignInInitial extends StatefulWidget {
  @override
  _SignInInitialState createState() => _SignInInitialState();
}

class _SignInInitialState extends State<SignInInitial> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image(
                image: AssetImage('assets/logo.png'),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email',
                ),
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
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
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
                  BlocProvider.of<AuthenticationBloc>(context).add(SignedIn(
                      email: emailController.text,
                      password: passwordController.text));
                }
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed('/sign_up');
                });
              },
              child: Text('Sign Up'),
            )
          ],
        ),
      ),
    );
  }
}

class SignInInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 15),
          Text('Loading...'),
        ],
      ),
    );
  }
}
