import 'package:flutter_test/flutter_test.dart';
import 'package:text_form_validator/form_validator.dart';

void main() {
  test('Required form validation', () {
    ValidationFn validator = FormValidator.builder().required().build();
    expect(null, validator("This should be valid"));
    expect(null, validator("1.001"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be empty", validator(null));
  });

  test('Required form validation different messages', () {
    ValidationFn validator = FormValidator.builder()
        .required(emptyError: "Bad empty!", nullError: "OeeeNullo")
        .build();
    expect(null, validator("This should be valid"));
    expect(null, validator("1.001"));
    expect("Bad empty!", validator(""));
    expect("OeeeNullo", validator(null));
  });

  test('Numeric form validation', () {
    ValidationFn validator =
        FormValidator.builder().required().isNumeric().build();
    expect(null, validator("1.1001"));
    expect("Field must be a valid number", validator("This should fail"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be empty", validator(null));
  });

  test('DateTime form validation', () {
    ValidationFn validator = FormValidator.builder()
        .required()
        .isDateTime(dateFormat: "dd.MM.yyyy")
        .build();
    expect(null, validator("10.02.1900"));
    expect("Field must be a valid date", validator("10/02/1900"));
    ValidationFn validator2 =
        FormValidator.builder().required().isDateTime().build();
    expect("Field must be a valid date", validator2("10.02.1900"));
    expect(null, validator2("10/02/1900"));

    expect("Field must be a valid date", validator("As should this"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be empty", validator(null));
  });

  test('Custom function validators', () {
    String customErorr = "Number must be a multiple of 100!";

    ValidationFn validator = FormValidator.builder()
        .notNull(errorMessage: "Woah enter something!")
        .notEmpty()
        .isNumeric()
        // If it hits the custom we can assume the types will convert properly
        .custom((p0) =>
            (p0 == null || (num.parse(p0) % 100) != 0) ? customErorr : null)
        .build();

    expect(null, validator("100"));
    expect(null, validator("1000"));
    expect(customErorr, validator("1"));
    expect(customErorr, validator("1.1001"));
    expect("Field must be a valid number", validator("This should fail"));
    expect("Field can't be empty", validator(""));
    expect("Woah enter something!", validator(null));
  });

  test('Length GT Test', () {
    int len = 3;
    String error = "Field length not greater than 3";
    ValidationFn validator = FormValidator.builder().lengthGt(len).build();

    // Null failure is undefined for this validation
    expect(null, validator(null));
    expect(error, validator(""));
    expect(error, validator("12"));
    expect(error, validator("123"));
    expect(null, validator("1234"));
    expect(null, validator("1234" * 5));
  });

  test('Length GT EQ Test', () {
    int len = 3;
    String error = "Field length not greater than or equal too 3";
    ValidationFn validator = FormValidator.builder().lengthGtEq(len).build();

    // Null failure is undefined for this validation
    expect(null, validator(null));
    expect(error, validator(""));
    expect(error, validator("12"));
    expect(null, validator("123"));
    expect(null, validator("1234"));
    expect(null, validator("1234" * 5));
  });

  test('Length LT Test', () {
    int len = 3;
    String error = "Field length not less than 3";
    ValidationFn validator = FormValidator.builder().lengthLt(len).build();

    // Null failure is undefined for this validation
    expect(null, validator(null));
    expect(null, validator(""));
    expect(null, validator("12"));
    expect(error, validator("123"));
    expect(error, validator("1234"));
    expect(error, validator("1234" * 5));
  });

  test('Length LT EQ Test', () {
    int len = 3;
    String error = "Field length not less than or equal too 3";
    ValidationFn validator = FormValidator.builder().lengthLtEq(len).build();

    // Null failure is undefined for this validation
    expect(null, validator(null));
    expect(null, validator(""));
    expect(null, validator("12"));
    expect(null, validator("123"));
    expect(error, validator("1234"));
    expect(error, validator("1234" * 5));
  });

  test('Length EQ Test', () {
    int len = 3;
    String error = "Field length not equal too 3";
    ValidationFn validator = FormValidator.builder().lengthEq(len).build();

    // Null failure is undefined for this validation
    expect(null, validator(null));
    expect(error, validator(""));
    expect(error, validator("12"));
    expect(null, validator("123"));
    expect(error, validator("1234"));
    expect(error, validator("1234" * 5));
  });

  test('In List', () {
    List<String> list = ['a', 'b', 'c'];
    String error = "Unexpected value";
    ValidationFn validator = FormValidator.builder().inList(list).build();

    expect(error, validator(null));
    expect(error, validator(""));
    expect(error, validator("12"));
    expect(null, validator("a"));
    expect(null, validator("b"));
    expect(null, validator("c"));
    expect(error, validator("cc"));
  });

  test('Not In List', () {
    List<String> list = ['a', 'b', 'c'];
    String error = "Unexpected value";
    ValidationFn validator = FormValidator.builder().notInList(list).build();

    expect(null, validator(null));
    expect(null, validator(""));
    expect(null, validator("12"));
    expect(error, validator("a"));
    expect(error, validator("b"));
    expect(error, validator("c"));
    expect(null, validator("cc"));
  });

  test('Regex', () {
    String pattern = r"[a-z][0-9]+_end";
    String error = "Field fails validation";
    ValidationFn validator = FormValidator.builder().matches(pattern).build();

    expect(error, validator(null));
    expect(error, validator(""));

    expect(null, validator("a99_end"));
    expect(null, validator("a9_end"));
    expect(null, validator("z123456789_end"));

    expect(error, validator("a99"));
    expect(error, validator("a9"));
    expect(error, validator("z123456789"));
  });

  test('Regex Email', () {
    String error = "Not a valid email";
    ValidationFn validator = FormValidator.builder().isAnEmail().build();

    expect(error, validator(null));
    expect(error, validator(""));

    expect(null, validator("asdjnasdkjlansdkjasndljk@gmail.com"));
    expect(null, validator("test@sankdnasdkl.com"));
    expect(null, validator("test@gmail.co"));
    expect(null, validator("test@gmail.coasdasda"));

    expect(error, validator("test@@gmail.com"));
    expect(error, validator("test@gmail..com"));
    expect(error, validator("@gmail.com"));
    expect(error, validator("@gmail.com"));
    expect(error, validator("test@.com"));
    expect(error, validator("test@gmail."));
    expect(error, validator("test@gmail.c"));

    String error1 = "Oeee, bad stuff!";
    ValidationFn validator1 =
        FormValidator.builder().isAnEmail(errorMessage: error1).build();

    expect(error1, validator1(null));
    expect(error1, validator1(""));

    expect(null, validator1("asdjnasdkjlansdkjasndljk@gmail.com"));
    expect(null, validator1("test@sankdnasdkl.com"));
    expect(null, validator1("test@gmail.co"));
    expect(null, validator1("test@gmail.coasdasda"));

    expect(error1, validator1("test@@gmail.com"));
    expect(error1, validator1("test@gmail..com"));
    expect(error1, validator1("@gmail.com"));
    expect(error1, validator1("@gmail.com"));
    expect(error1, validator1("test@.com"));
    expect(error1, validator1("test@gmail."));
    expect(error1, validator1("test@gmail.c"));
  });
}
