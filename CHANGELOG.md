## 0.0.1
The inital release of the project. Should include all the basic functionality
required to do form validation with the ability to specify any custom functionality
to be added into the base library

## 1.0.0
Changes the error returning "null" to be the same as the empty message as it is
more user firendly.

Also adds the following new validators (along with tests):
    - Length (>, >=, ==, <=, <)
    - List (contains, !contains)
    - Regex (and a specified email helper)

## 1.0.1
Fixed a bug where the added message text was been ignored.

Improved the email failure text to be less generic.