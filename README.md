# Form Validator

This package is intended to help create informative validation for flutter
form fields.

## Features

The `FormValidator` class is inteneded to be used to chain validation
functions together to produce one validator function as required by Widgets
such as `TextFormField`. The final closure using the build method matches
the type required by the validator attribute for form fields '`String? Function(String?)`'.

## Getting started

To use this pacakge add `form_validator` as a package in your pub file.

## Usage


```dart
import 'package:form_validator/form_validator.dart';
// Basic, the field can't be null or empty
TextFormField(validator: FormValidator.required().build());

// All the messages which will be returned from validation can't be customised
// as required. Each validator is run one after the other, so the message
// to the end user can be as specific as possible
TextFormField(validator: FormValidator.builder()
    .notNull(nullError: "Woah enter something!")
    .notEmpty()
    .isNumeric()
    .build());

// More complex validation can also be added on the fly
String customErorr = "Number must be a multiple of 100!";

ValidationFn validator = FormValidator.builder()
    .notNull(nullError: "Woah enter something!")
    .notEmpty()
    .isNumeric()
    // If it hits the custom we can assume the types will convert properly
    .custom((p0) => (p0 == null || (num.parse(p0) % 100) != 0) ? customErorr : null)
    .build();

TextFormField(validator: validator);
```

## Current Default Functions
Below is a list of all current default functions provided, as specified these
are here to assist the user, and may not be exhaustive, see `FormValidator.custom`
for adding custom functions. The descriptions provided here are breif, check the
functions themselves in `utils/string_validation_functions.dart` for full details.

### Default Functions List
 - `notNull`: Not equal to null
 - `notEmpty`: Not equal to ""
 - `required`: Combines `notNull` and `notEmpty`
 - `isNumeric`: `num.tryParse` != null
 - `isDateTime`: The value can be formatted into a date (can specify custom format)
 - `equals`: == provided value
 - `notEquals`: != provided value
 - `lengthGt`: value.length > providedValue
 - `lengthGtEq`: value.length >= providedValue
 - `lengthLt`: value.length < providedValue
 - `lengthLtEq`: value.length <= providedValue
 - `lengthEq`: value.length == providedValue
 - `inList`: The value is in the provided list
 - `notInList`: The value is not in the provided list
 - `matches`: The value matches the supplied regex pattern
 - `isAnEmail`: The value matches the `StraingValidationFunctions.emailRegExp` pattern
## Additional information

The benefit of the chaining of functions allow user messages to be as customized
as possible.

For `StraingValidationFunctions` errors are provided in line. This allows for
errors like in `StraingValidationFunctions.equals` where it specifies the equal
value in the default error.