library form_validator;

import 'dart:collection';

import 'package:intl/intl.dart';

typedef ValidationFn = String? Function(String?);

class FormValidator {
  static ValidatorBuilder builder() {
    return ValidatorBuilder(null, null, null);
  }

  static String? reqd(String? s, {String? nullError, String? emptyError}) {
    return FormValidator.builder()._mergeFNs(
      (s) => FormValidator.notNull(s, nullError: nullError),
      (s) => FormValidator.notEmpty(s, emptyError: emptyError),
    )(s);
  }

  static String? notNull(String? s, {String? nullError, String? emptyError}) {
    if (s == null) {
      return nullError ?? "Field can't be null";
    }
    return null;
  }

  static String? notEmpty(String? s, {String? nullError, String? emptyError}) {
    if (s == "") {
      return emptyError ?? "Field can't be empty";
    }
    return null;
  }

  static String? isNumeric(String? s, {String? nonNumericError}) {
    if (s == null || num.tryParse(s) == null) {
      return nonNumericError ?? "Field must be a valid number";
    }
    return null;
  }

  static String? isDateTime(String? s, {String dateFormat = "dd/MM/yyyy", bool parseLoose = false, String? dateError}) {
    DateFormat df = DateFormat(dateFormat);
    var parseFn = parseLoose ? df.parseLoose : df.parse;

    try {
      if (s == null) {
        throw const FormatException();
      }
      parseFn(s);
    } on FormatException {
      return dateError ?? "Field must be a valid date";
    }

    return null;
  }

  static String? equals(String? s, String equals, {String? notEqualError}) {
    if (s != equals) {
      return notEqualError ?? "Field does not equal '$equals'";
    }
    return null;
  }

  static String? notEquals(String? s, String equals, {String? notEqualError}) {
    if (s == equals) {
      return notEqualError ?? "Field does equals '$equals'";
    }
    return null;
  }
}

class ValidatorBuilder {
  final ValidatorBuilder? prev;
  ValidatorBuilder? next;
  ValidationFn? validator;

  ValidatorBuilder(this.prev, this.next, this.validator);

  ValidatorBuilder reqd({String? nullError, String? emptyError}) {
    return _chain((String? s) => FormValidator.reqd(s, nullError: nullError, emptyError: emptyError));
  }

  ValidatorBuilder notNull({String? nullError, String? emptyError}) {
    return _chain((String? s) => FormValidator.notNull(s, nullError: nullError, emptyError: emptyError));
  }

  ValidatorBuilder notEmpty({String? nullError, String? emptyError}) {
    return _chain((String? s) => FormValidator.notEmpty(s, nullError: nullError, emptyError: emptyError));
  }

  ValidatorBuilder isNumeric({String? nonNumericError}) {
    return _chain((String? s) => FormValidator.isNumeric(s, nonNumericError: nonNumericError));
  }

  ValidatorBuilder isDateTime({String? dateError, String dateFormat = "dd/MM/yyyy", bool parseLoose = false}) {
    return _chain((String? s) =>
        FormValidator.isDateTime(s, dateError: dateError, dateFormat: dateFormat, parseLoose: parseLoose));
  }

  ValidatorBuilder isEqualTo(String equals, {String? notEqualError}) {
    return _chain((String? s) => FormValidator.equals(s, equals, notEqualError: notEqualError));
  }

  ValidatorBuilder notEqualTo(String equals, {String? notEqualError}) {
    return _chain((String? s) => FormValidator.notEquals(s, equals, notEqualError: notEqualError));
  }

  /// Allows for a custom function to be added into the chaining sequence
  ValidatorBuilder custom(ValidationFn fn) {
    return _chain(fn);
  }

  /// Used to help link together the stages of the builder
  ValidatorBuilder _chain(ValidationFn fn) {
    ValidatorBuilder nxt = ValidatorBuilder(this, null, fn);
    next = nxt;
    return nxt;
  }

  /// Merges two String function types from 'String -> String -> String' into 'String -> String'
  ValidationFn _mergeFNs(ValidationFn a, ValidationFn b) {
    return (String? x) => a(x) ?? b(x);
  }

  // Used to merge all links of the chain into the final function closure
  ValidationFn build() {
    ListQueue<ValidationFn> validators = ListQueue();

    ValidatorBuilder? current = this;

    while (current != null) {
      // current.validators type couldn't be resolved properly in the add
      // first, so to avoid typing issues we make the local variable
      ValidationFn? v = current.validator;
      if (v != null) {
        validators.addFirst(v);
      }
      current = current.prev;
    }

    return validators.fold((String? _) => null, (a, b) => _mergeFNs(a, b));
  }
}
