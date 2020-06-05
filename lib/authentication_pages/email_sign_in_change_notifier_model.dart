import 'package:chat_app/authentication_pages/validators.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum EmailSignFormType { Register, Login }

class EmailSignInChangeNotifierModel
    with EmailAndPasswordValidator, ChangeNotifier {
  EmailSignInChangeNotifierModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.username = '',
    this.formType = EmailSignFormType.Register,
    this.loading = false,
    this.submitted = false,
  });
  Auth auth;
  bool loading;
  String email;
  String password;
  String username;
  EmailSignFormType formType;
  bool submitted;

  void toggleFormType() {
    final formType = this.formType == EmailSignFormType.Register
        ? EmailSignFormType.Login
        : EmailSignFormType.Register;
    updateWith(
        email: '',
        password: '',
        username: '',
        formType: formType,
        loading: false,
        submitted: false);
  }

  void submit() async {
    updateWith(loading: true, submitted: true);
    try {
      if (this.formType == EmailSignFormType.Register) {
        await auth.createUserWithEmailAndPassword(email, password, username);
      } else {
        await auth.signInUserWithEmailAndPassword(email, password);
      }
    } on PlatformException catch (e) {
      rethrow;
    } finally {
      updateWith(loading: false);
    }
  }

  void googleSignIn() async {
    updateWith(loading: true, submitted: true);
    try {
      await auth.signInWithGoogle(username);
    } catch (e) {
      rethrow;
    } finally {
      updateWith(loading: false);
    }
  }

  String get showPasswordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(this.password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get showUsernameErrorText {
    bool showErrorText = submitted && !usernameValidator.isValid(this.username);
    return showErrorText ? invalidUsernameErrorText : null;
  }

  String get showEmailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(this.email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !loading;
  }

  void updateEmail(String value) => updateWith(email: value);
  void updatePassword(String value) => updateWith(password: value);
  void updateUsername(String value) => updateWith(username: value);

  void updateWith({
    String email,
    String password,
    EmailSignFormType formType,
    bool loading,
    String username,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.loading = loading ?? this.loading;
    this.username = username ?? this.username;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
