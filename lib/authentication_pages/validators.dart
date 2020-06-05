abstract class StringValidators {
  bool isValid(String value);
}

class NonEmptyStringValidators extends StringValidators {
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidator {
  StringValidators emailValidator = NonEmptyStringValidators();
  StringValidators passwordValidator = NonEmptyStringValidators();
  StringValidators usernameValidator = NonEmptyStringValidators();
  final String invalidUsernameErrorText = 'Username can\'t be empty';
  final String invalidEmailErrorText = 'Email can\'t be Empty';
  final String invalidPasswordErrorText = 'Password can\'t be Empty';
}
