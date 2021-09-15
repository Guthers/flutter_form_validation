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
  static String? notNull(String? checkValue, {String? errorMessage}) {
    if (checkValue == null) {
      return errorMessage ?? "Field can't be empty";
    }
    return null;
  }

  /// Checks that [checkValue] is not equal to [""].
  ///
  /// If [checkValue] is equal to [""] the function will return [errorMessage] if provided,
  /// or the default error if not. Otherwise [null] is returned
  static String? notEmpty(String? checkValue, {String? errorMessage}) {
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
  static String? isNumeric(String? checkValue, {String? errorMessage}) {
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
  static String? equals(String? checkValue, String compareValue, {String? errorMessage}) {
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
  static String? notEquals(String? checkValue, String compareValue, {String? errorMessage}) {
    if (checkValue == compareValue) {
      return errorMessage ?? "Field does equals '$compareValue'";
    }
    return null;
  }

  /// Checks that the length of [checkValue] is greater than then [gt]
  ///
  /// If [checkValue] is not null and [checkValue.length] is not greater than
  /// [gt] than [errorMessage] is returned if provided, else the default error
  /// is provided. Otherwise null is returned
  static String? lengthGt(String? checkValue, int gt, {String? errorMessage}) {
    if (checkValue != null && !(checkValue.length > gt)) {
      return errorMessage ?? "Field length not greater than $gt";
    }
    return null;
  }

  /// Checks that the length of [checkValue] is greater then or equal to [gtEq]
  ///
  /// If [checkValue] is not null and [checkValue.length] is not greater than or
  /// equal to [gtEq] than [errorMessage] is returned if provided, else the default
  /// error is provided. Otherwise null is returned
  static String? lengthGtEq(String? checkValue, int gtEq, {String? errorMessage}) {
    if (checkValue != null && !(checkValue.length >= gtEq)) {
      return errorMessage ?? "Field length not greater than or equal too $gtEq";
    }
    return null;
  }

  /// Checks that the length of [checkValue] is less then [lt]
  ///
  /// If [checkValue] is not null and [checkValue.length] is not less than
  /// [lt] than [errorMessage] is returned if provided, else the default error
  /// is provided. Otherwise null is returned
  static String? lengthLt(String? checkValue, int lt, {String? errorMessage}) {
    if (checkValue != null && !(checkValue.length < lt)) {
      return errorMessage ?? "Field length not less than $lt";
    }
    return null;
  }

  /// Checks that the length of [checkValue] is less then or equal to [ltEq]
  ///
  /// If [checkValue] is not null and [checkValue.length] is not less than or
  /// equal to [ltEq] than [errorMessage] is returned if provided, else the default
  /// is provided. Otherwise null is returned
  static String? lengthLtEq(String? checkValue, int ltEq, {String? errorMessage}) {
    if (checkValue != null && !(checkValue.length <= ltEq)) {
      return errorMessage ?? "Field length not less than or equal too $ltEq";
    }
    return null;
  }

  /// Checks that the length of [checkValue] is equal to [eq]
  ///
  /// If [checkValue] is not null and [checkValue.length] is nequal to [ltEq]
  /// than [errorMessage] is returned if provided, else the default is provided.
  /// Otherwise null is returned
  static String? lengthEq(String? checkValue, int eq, {String? errorMessage}) {
    if (checkValue != null && !(checkValue.length == eq)) {
      return errorMessage ?? "Field length not equal too $eq";
    }
    return null;
  }

  /// Checks if [checkValue] is in the provided list
  ///
  /// If [checkValue] is not in the provided list than [errorMessage] will be
  /// returned if provided, else the default message is returned. Othersie null
  /// is returned
  static String? inList(String? checkValue, List<String> list, {String? errorMessage}) {
    return list.contains(checkValue) ? null : "Unexpected value";
  }

  /// Checks if [checkValue] is not in the provided list
  ///
  /// If [checkValue] is in the provided list than [errorMessage] will be
  /// returned if provided, else the default message is returned. Othersie null
  /// is returned
  static String? notInList(String? checkValue, List<String> list, {String? errorMessage}) {
    return list.contains(checkValue) ? "Unexpected value" : null;
  }

  /// Checks if [checkValue] can be matched by the regular expression [pattern]
  ///
  /// If [checkValue] is null or is not matched by the RegEx [pattern] the
  /// [errorMessage] will be returned if provided, otherwise the default error.
  /// Otherwise null is returned
  static String? matches(String? checkValue, String pattern, {String? errorMessage}) {
    return ((checkValue == null) || !RegExp(pattern).hasMatch(checkValue)) ? "Field fails validation" : null;
  }

  static const String emailRegExp = r"[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}";

  /// Checks if [checkValue] can be matched by the regular expression [emailRegExp]
  ///
  /// If [checkValue] is null or is not matched by [emailRegExp] the [errorMessage]
  /// will be returned if provided, otherwise the default error. Otherwise null
  /// is returned
  static String? isAnEmail(String? checkValue, {String? errorMessage}) {
    return matches(checkValue, emailRegExp);
  }
}
