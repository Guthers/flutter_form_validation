/// form_validator provides a way of composing different validation functions
/// into one result for use in TextFormFields
library text_form_validator;

import 'dart:collection';

import 'package:text_form_validator/utils/string_validation_functions.dart';

typedef ValidationFn = String? Function(String?);

class FormValidator {
  // Creates the linking to chain validators together
  final FormValidator? prev;
  FormValidator? next;
  // The validation function at this node
  ValidationFn? validator;

  // The basic entry point for creating a new builder
  factory FormValidator.builder() => FormValidator(null, null, null);

  FormValidator(this.prev, this.next, this.validator);

  /// Used to help link together the stages of the builder
  FormValidator _chain(ValidationFn fn) {
    FormValidator nxt = FormValidator(this, null, fn);
    next = nxt;
    return nxt;
  }

  /// Used to merge all links of the chain into a final function of type [ValidationFn]
  ValidationFn build() {
    ListQueue<ValidationFn> validators = ListQueue();

    FormValidator? current = this;

    while (current != null) {
      // current.validators type couldn't be resolved properly in the add
      // first, so to avoid typing issues we make the local variable
      ValidationFn? v = current.validator;
      if (v != null) {
        validators.addFirst(v);
      }
      current = current.prev;
    }

    return validators.fold((String? _) => null, (a, b) => mergeFNs(a, b));
  }

  ///
  /// The below functions are provided to allow for extension of the base
  /// validation functionality.

  /// Allows for a custom function to be added into the chaining sequence
  ///
  /// Below is an example of ensuring that a number is a multiple of 100.
  /// ```dart
  /// ValidationFn validator = FormValidator.builder()
  ///     .notNull()
  ///     .notEmpty()
  ///     .isNumeric()
  ///     .custom((p0) => (p0 == null || (num.parse(p0) % 100) != 0) ? customErorr : null)
  ///     .build();
  /// ```
  FormValidator custom(ValidationFn fn) {
    return _chain(fn);
  }

  /// Merges two functions of type [ValidationFn] into one function of type [ValidationFn]
  ///
  /// Below is an example of ensuring that a number is a multiple of 100.
  /// ```dart
  /// FormValidator
  ///   .builder()
  ///   .notNull()
  ///   .notEmpty()
  ///   .build();
  /// //Is the same as
  /// FormValidator
  ///   .mergeFNs(
  ///     StraingValidationFunctions.notNull,
  ///     StraingValidationFunctions.notEmpty
  ///   );
  /// ```
  static ValidationFn mergeFNs(ValidationFn a, ValidationFn b) {
    return (String? x) => a(x) ?? b(x);
  }

  ///
  /// Below are base case validatior functions, they are provided to cover
  /// most basic use cases that might be encountered.
  ///
  /// They use the validation functions from [StraingValidationFunctions] to
  /// complete the actual validation
  ///

  /// Adds [StraingValidationFunctions.required] to the function validation chain
  FormValidator required({String? nullError, String? emptyError}) {
    return _chain((String? s) => StraingValidationFunctions.required(s,
        nullErrorMessage: nullError, emptyErrorMessage: emptyError));
  }

  /// Adds [StraingValidationFunctions.notNull] to the function validation chain
  FormValidator notNull({String? errorMessage}) {
    return _chain((String? s) =>
        StraingValidationFunctions.notNull(s, errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.notEmpty] to the function validation chain
  FormValidator notEmpty({String? errorMessage}) {
    return _chain((String? s) =>
        StraingValidationFunctions.notEmpty(s, errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.isNumeric] to the function validation chain
  FormValidator isNumeric({String? errorMessage}) {
    return _chain((String? s) =>
        StraingValidationFunctions.isNumeric(s, errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.isDateTime] to the function validation chain
  FormValidator isDateTime(
      {String? errorMessage,
      String dateFormat = "dd/MM/yyyy",
      bool parseLoose = false}) {
    return _chain((String? s) => StraingValidationFunctions.isDateTime(s,
        errorMessage: errorMessage,
        dateFormat: dateFormat,
        parseLoose: parseLoose));
  }

  /// Adds [StraingValidationFunctions.equals] to the function validation chain
  FormValidator isEqualTo(String equals, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.equals(s, equals,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.notEquals] to the function validation chain
  FormValidator notEqualTo(String equals, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.notEquals(s, equals,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.lengthGt] to the function validation chain
  FormValidator lengthGt(int length, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.lengthGt(s, length,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.lengthGtEq] to the function validation chain
  FormValidator lengthGtEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.lengthGtEq(
        s, length,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.lengthLt] to the function validation chain
  FormValidator lengthLt(int length, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.lengthLt(s, length,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.lengthLtEq] to the function validation chain
  FormValidator lengthLtEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.lengthLtEq(
        s, length,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.lengthEq] to the function validation chain
  FormValidator lengthEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.lengthEq(s, length,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.inList] to the function validation chain
  FormValidator inList(List<String> list, {String? errorMessage}) {
    return _chain((String? s) =>
        StraingValidationFunctions.inList(s, list, errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.notInList] to the function validation chain
  FormValidator notInList(List<String> list, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.notInList(s, list,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.matches] to the function validation chain
  FormValidator matches(String pattern, {String? errorMessage}) {
    return _chain((String? s) => StraingValidationFunctions.matches(s, pattern,
        errorMessage: errorMessage));
  }

  /// Adds [StraingValidationFunctions.isAnEmail] to the function validation chain
  FormValidator isAnEmail({String? errorMessage}) {
    return _chain((String? s) =>
        StraingValidationFunctions.isAnEmail(s, errorMessage: errorMessage));
  }
}
