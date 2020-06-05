import 'package:chat_app/authentication_pages/email_sign_in_change_notifier_model.dart';
import 'package:chat_app/authentication_pages/sign_in_bloc.dart';
import 'package:chat_app/authentication_pages/validators.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EmailSignInPage extends StatefulWidget with EmailAndPasswordValidator {
  final EmailSignInChangeNotifierModel model;
  EmailSignInPage({@required this.model});
  static Widget create(BuildContext context) {
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeNotifierModel>(
      create: (context) => EmailSignInChangeNotifierModel(auth: auth),
      child: Consumer<EmailSignInChangeNotifierModel>(
        builder: (context, model, _) => EmailSignInPage(model: model),
      ),
    );
  }

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _onEditingComplete(BuildContext context) {
    final newFocus = widget.model.emailValidator.isValid(widget.model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _onUsernameEditingComplete(BuildContext context) {
    final newEmailFocus =
        widget.model.usernameValidator.isValid(widget.model.username)
            ? _emailFocusNode
            : _usernameFocusNode;
    FocusScope.of(context).requestFocus(newEmailFocus);
  }

  void _submit(BuildContext context) async {
    try {
      await widget.model.submit();
    } on PlatformException catch (e) {
      print("${e.code} , ${e.details}, ${e.message}");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("${e.code}"),
            content: new Text("${e.details}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _googleSignIn(BuildContext context) async {
    try {
      widget.model.googleSignIn();
    } on PlatformException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("${e.code}"),
            content: new Text("${e.details}"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://raw.githubusercontent.com/oliver-gomes/flutter-loginui/master/assets/images/1.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(child: _mainContent(context)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 15),
          widget.model.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Text(
                  "Welcome!",
                  style: TextStyle(color: Colors.deepPurple, fontSize: 45),
                  textAlign: TextAlign.center,
                ),
          widget.model.formType == EmailSignFormType.Register
              ? SizedBox(height: 15)
              : SizedBox(),
          widget.model.formType == EmailSignFormType.Register
              ? _usernameInputField(context)
              : SizedBox(),
          SizedBox(height: 15),
          _emailInputField(context),
          SizedBox(height: 10),
          _passwordInputField(context),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: RaisedButton(
              color: Colors.deepPurple,
              child: Text(
                widget.model.formType == EmailSignFormType.Login
                    ? 'Login'
                    : 'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _submit(context),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: RaisedButton(
              color: Colors.white,
              elevation: 0,
              child: Text(
                widget.model.formType == EmailSignFormType.Login
                    ? 'Don\'t have and account? Sign up'
                    : 'Already have an Account ? Log in',
                style: TextStyle(color: Colors.deepPurple),
              ),
              onPressed: _toggleFormType,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'or',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: AssetImage("asset/google.jpg"),
                  backgroundColor: Colors.black,
                  radius: 25,
                ),
                onTap: () => _googleSignIn(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _usernameInputField(BuildContext context) {
    return TextField(
      controller: _usernameController,
      cursorColor: Colors.deepPurple,
      focusNode: _usernameFocusNode,
      onEditingComplete: () => _onUsernameEditingComplete(context),
      onChanged: widget.model.updateUsername,
      style: TextStyle(color: Colors.deepPurple),
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.deepPurple),
          labelText: 'Username',
          errorText: widget.model.showUsernameErrorText,
          prefixIcon: Icon(
            Icons.person,
            color: Colors.deepPurple,
          )),
      enabled: widget.model.loading == false,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _emailInputField(BuildContext context) {
    return TextField(
      controller: _emailController,
      cursorColor: Colors.deepPurple,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _onEditingComplete(context),
      onChanged: widget.model.updateEmail,
      style: TextStyle(color: Colors.deepPurple),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.deepPurple),
          labelText: 'Email',
          hintText: 'test@abc.com',
          errorText: widget.model.showEmailErrorText,
          prefixIcon: Icon(
            Icons.email,
            color: Colors.deepPurple,
          )),
      enabled: widget.model.loading == false,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _passwordInputField(BuildContext context) {
    return TextField(
      cursorColor: Colors.deepPurple,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      onChanged: widget.model.updatePassword,
      onEditingComplete: () => _submit(context),
      style: TextStyle(color: Colors.deepPurple),
      decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.deepPurple),
          labelText: 'Password',
          errorText: widget.model.showPasswordErrorText,
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.deepPurple,
          )),
      enabled: widget.model.loading == false,
      textInputAction: TextInputAction.done,
      obscureText: true,
    );
  }
}
