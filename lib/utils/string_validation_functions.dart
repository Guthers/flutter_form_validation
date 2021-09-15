import 'package:intl/intl.dart';

// This class provides the base validation functions used by the FormValidator
class StraingValidationFunctions {
  /// Checks that the string is not null then checks if the string is empty
  static String? required(String? checkValue, {String? nullErrorMessage, String? emptyErrorMessage}) {
    return StraingValidationFunctions.notNull(checkValue, errorMessage: nullErrorMessage) ??
        StraingValidationFunctions.notEmpty(checkValue, errorMessage: emptyErrorMessage);
  }

  /// Checks that [checkValue] is not null.
  ///
  /// If [checkValue] is null the function will return [errorMessage] if provided,
  /// or the default error if not. Otherwise [null] is returned
  static String? notNull(String? checkValue, {errorMessage}) {
    if (checkValue == null) {
      return errorMessage ?? "Field can't be null";
    }
    return null;
  }

  /// Checks that [checkValue] is not equal to [""].
  ///
  /// If [checkValue] is equal to [""] the function will return [errorMessage] if provided,
  /// or the default error if not. Otherwise [null] is returned
  static String? notEmpty(String? checkValue, {errorMessage}) {
    if (checkValue == "") {
      return errorMessage ?? "Field can't be empty";
    }
    return null;
  }

  /// Checks that [checkValue] can be turned into a number
  ///
  /// If [checkValue] can't be turned into a number the function will return
  /// [errorMessage] if provided, or the default error if not.
  /// Otherwise [null] is returned
  static String? isNumeric(String? checkValue, {errorMessage}) {
    if (checkValue == null || num.tryParse(checkValue) == null) {
      return errorMessage ?? "Field must be a valid number";
    }
    return null;
  }

  /// Checks that [checkValue] can be turned into a datetime.
  ///
  /// [DateFormat] will be used to attempt to parse [checkValue]. Using the format
  /// provided by [dateFormat]. If [checkValue] can't be passed then [errorMessage] if provided,
  /// or the default error if not. Otherwise [null] is returned
  static String? isDateTime(String? checkValue,
      {String dateFormat = "dd/MM/yyyy", bool parseLoose = false, errorMessage}) {
    DateFormat df = DateFormat(dateFormat);
    var parseFn = parseLoose ? df.parseLoose : df.parse;

    try {
      if (checkValue == null) {
        throw const FormatException();
      }
      parseFn(checkValue);
    } on FormatException {
      return errorMessage ?? "Field must be a valid date";
    }

    return null;
  }

  /// Checks that [checkValue] equals [compareValue].
  ///
  /// Attempts to compare [checkValue] and [compareValue]. If they are not
  /// equal than [errorMessage] is returned if provided, or the default error if not.
  /// Otherwise [null] is returned
  static String? equals(String? checkValue, String compareValue, {errorMessage}) {
    if (checkValue != compareValue) {
      return errorMessage ?? "Field does not equal '$compareValue'";
    }
    return null;
  }

  /// Checks that [checkValue] does not equal [compareValue].
  ///
  /// Attempts to compare [checkValue] and [compareValue]. If they are equal than
  /// [errorMessage] is returned if provided, or the default error if not.
  /// Otherwise [null] is returned
  static String? notEquals(String? checkValue, String compareValue, {errorMessage}) {
    if (checkValue == compareValue) {
      return errorMessage ?? "Field does equals '$compareValue'";
    }
    return null;
  }
}
