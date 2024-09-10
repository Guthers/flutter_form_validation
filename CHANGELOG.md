## 0.0.1

The inital release of the project. Should include all the basic functionality
required to do form validation with the ability to specify any custom functionality
to be added into the base library

## 1.0.0

Changes the error returning "null" to be the same as the empty message as it is
more user firendly.

Also adds the following new validators (along with tests): - Length (>, >=, ==, <=, <) - List (contains, !contains) - Regex (and a specified email helper)

## 1.0.1

Fixed a bug where the added message text was been ignored.

Improved the email failure text to be less generic.

## 1.0.2

Adds an example, and formats the library to 80 characters

## 1.0.3

Fixes incorrect naming from `form_validator` to `text_form_validator`

## 1.0.4

Changes `intl` and `flutter_lints` version dependency to `any`

## 1.0.5

Fixes a bunch of spelling issues

## 1.0.6

Deprecated `FormValidator.builder()` in favour of direct creation `FormValidator()`
Also adds a bunch of factories to allow for top direct chain starts `FormValidator.required()` instead of `FormValidator().required()`
Make the FormValidator class immutable as well
