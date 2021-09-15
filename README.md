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
TextFormField(validator: FormValidator.reqd().build());

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

## Additional information

The benefit of the chaining of functions allow user messages to be as customized
as possible.