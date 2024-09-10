/// form_validator provides a way of composing different validation functions
/// into one result for use in TextFormFields
library text_form_validator;

import "dart:collection";

import "package:flutter/foundation.dart";
import "package:text_form_validator/utils/string_validation_functions.dart";

typedef ValidationFn = String? Function(String?);

@immutable
class FormValidator {
  // Creates the linking to chain validators together
  final FormValidator? prev;
  // The validation function at this node
  final ValidationFn? validator;

  @Deprecated(
      "Now not preferred as overly verbose, use FormValidator() instead")
  factory FormValidator.builder() => const FormValidator();

  const FormValidator({this.prev, this.validator});

  /// Used to help link together the stages of the builder
  FormValidator _chain(ValidationFn fn) =>
      FormValidator(prev: this, validator: fn);

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

  /// Helper function for when using the validation directly
  String? validate(String? value) => build()(value);

  ///
  /// The below functions are provided to allow for extension of the base
  /// validation functionality.

  /// Allows for a custom function to be added into the chaining sequence
  ///
  /// Below is an example of ensuring that a number is a multiple of 100.
  /// ```dart
  /// ValidationFn validator = FormValidator
  ///     .notNull()
  ///     .notEmpty()
  ///     .isNumeric()
  ///     .custom((p0) => (p0 == null || (num.parse(p0) % 100) != 0) ? customError : null)
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
  ///     StringValidationFunctions.notNull,
  ///     StringValidationFunctions.notEmpty
  ///   );
  /// ```
  static ValidationFn mergeFNs(ValidationFn a, ValidationFn b) {
    return (String? x) => a(x) ?? b(x);
  }

  ///
  /// Below are base case validator functions, they are provided to cover
  /// most basic use cases that might be encountered.
  ///
  /// They use the validation functions from [StringValidationFunctions] to
  /// complete the actual validation
  ///

  /// Adds [StringValidationFunctions.required] to the function validation chain
  FormValidator required({String? nullError, String? emptyError}) {
    return _chain((String? s) => StringValidationFunctions.required(s,
        nullErrorMessage: nullError, emptyErrorMessage: emptyError));
  }

  factory FormValidator.required({String? nullError, String? emptyError}) =>
      const FormValidator()
          .required(nullError: nullError, emptyError: emptyError);

  /// Adds [StringValidationFunctions.notNull] to the function validation chain
  FormValidator notNull({String? errorMessage}) {
    return _chain((String? s) =>
        StringValidationFunctions.notNull(s, errorMessage: errorMessage));
  }

  factory FormValidator.notNull({String? errorMessage}) =>
      const FormValidator().notNull(errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.notEmpty] to the function validation chain
  FormValidator notEmpty({String? errorMessage}) {
    return _chain((String? s) =>
        StringValidationFunctions.notEmpty(s, errorMessage: errorMessage));
  }

  factory FormValidator.notEmpty({String? errorMessage}) =>
      const FormValidator().notEmpty(errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.isNumeric] to the function validation chain
  FormValidator isNumeric({String? errorMessage}) {
    return _chain((String? s) =>
        StringValidationFunctions.isNumeric(s, errorMessage: errorMessage));
  }

  factory FormValidator.isNumeric({String? errorMessage}) =>
      const FormValidator().isNumeric(errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.isDateTime] to the function validation chain
  FormValidator isDateTime(
      {String? errorMessage,
      String dateFormat = "dd/MM/yyyy",
      bool parseLoose = false}) {
    return _chain((String? s) => StringValidationFunctions.isDateTime(s,
        errorMessage: errorMessage,
        dateFormat: dateFormat,
        parseLoose: parseLoose));
  }

  factory FormValidator.isDateTime(
          {String? errorMessage,
          String dateFormat = "dd/MM/yyyy",
          bool parseLoose = false}) =>
      const FormValidator().isDateTime(
          errorMessage: errorMessage,
          dateFormat: dateFormat,
          parseLoose: parseLoose);

  /// Adds [StringValidationFunctions.equals] to the function validation chain
  FormValidator isEqualTo(String equals, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.equals(s, equals,
        errorMessage: errorMessage));
  }

  factory FormValidator.isEqualTo(String equals, {String? errorMessage}) =>
      const FormValidator().isEqualTo(equals, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.notEquals] to the function validation chain
  FormValidator notEqualTo(String equals, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.notEquals(s, equals,
        errorMessage: errorMessage));
  }

  factory FormValidator.notEqualTo(String equals, {String? errorMessage}) =>
      const FormValidator().notEqualTo(equals, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.lengthGt] to the function validation chain
  FormValidator lengthGt(int length, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.lengthGt(s, length,
        errorMessage: errorMessage));
  }

  factory FormValidator.lengthGt(int length, {String? errorMessage}) =>
      const FormValidator().lengthGt(length, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.lengthGtEq] to the function validation chain
  FormValidator lengthGtEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.lengthGtEq(s, length,
        errorMessage: errorMessage));
  }

  factory FormValidator.lengthGtEq(int length, {String? errorMessage}) =>
      const FormValidator().lengthGtEq(length, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.lengthLt] to the function validation chain
  FormValidator lengthLt(int length, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.lengthLt(s, length,
        errorMessage: errorMessage));
  }

  factory FormValidator.lengthLt(int length, {String? errorMessage}) =>
      const FormValidator().lengthLt(length, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.lengthLtEq] to the function validation chain
  FormValidator lengthLtEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.lengthLtEq(s, length,
        errorMessage: errorMessage));
  }

  factory FormValidator.lengthLtEq(int length, {String? errorMessage}) =>
      const FormValidator().lengthLtEq(length, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.lengthEq] to the function validation chain
  FormValidator lengthEq(int length, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.lengthEq(s, length,
        errorMessage: errorMessage));
  }

  factory FormValidator.lengthEq(int length, {String? errorMessage}) =>
      const FormValidator().lengthEq(length, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.inList] to the function validation chain
  FormValidator inList(List<String> list, {String? errorMessage}) {
    return _chain((String? s) =>
        StringValidationFunctions.inList(s, list, errorMessage: errorMessage));
  }

  factory FormValidator.inList(List<String> list, {String? errorMessage}) =>
      const FormValidator().inList(list, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.notInList] to the function validation chain
  FormValidator notInList(List<String> list, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.notInList(s, list,
        errorMessage: errorMessage));
  }

  factory FormValidator.notInList(List<String> list, {String? errorMessage}) =>
      const FormValidator().notInList(list, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.matches] to the function validation chain
  FormValidator matches(String pattern, {String? errorMessage}) {
    return _chain((String? s) => StringValidationFunctions.matches(s, pattern,
        errorMessage: errorMessage));
  }

  factory FormValidator.matches(String pattern, {String? errorMessage}) =>
      const FormValidator().matches(pattern, errorMessage: errorMessage);

  /// Adds [StringValidationFunctions.isAnEmail] to the function validation chain
  FormValidator isAnEmail({String? errorMessage}) {
    return _chain((String? s) =>
        StringValidationFunctions.isAnEmail(s, errorMessage: errorMessage));
  }

  factory FormValidator.isAnEmail({String? errorMessage}) =>
      const FormValidator().isAnEmail(errorMessage: errorMessage);
}
