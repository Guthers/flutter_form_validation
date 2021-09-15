import 'package:flutter_test/flutter_test.dart';
import 'package:form_validator/form_validator.dart';

void main() {
  test('Required form validation', () {
    ValidationFn validator = FormValidator.builder().required().build();
    expect(null, validator("This should be valid"));
    expect(null, validator("1.001"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be null", validator(null));
  });

  test('Required form validation different messages', () {
    ValidationFn validator = FormValidator.builder().required(emptyError: "Bad empty!", nullError: "OeeeNullo").build();
    expect(null, validator("This should be valid"));
    expect(null, validator("1.001"));
    expect("Bad empty!", validator(""));
    expect("OeeeNullo", validator(null));
  });

  test('Numeric form validation', () {
    ValidationFn validator = FormValidator.builder().required().isNumeric().build();
    expect(null, validator("1.1001"));
    expect("Field must be a valid number", validator("This should fail"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be null", validator(null));
  });

  test('DateTime form validation', () {
    ValidationFn validator = FormValidator.builder().required().isDateTime(dateFormat: "dd.MM.yyyy").build();
    expect(null, validator("10.02.1900"));
    expect("Field must be a valid date", validator("10/02/1900"));
    ValidationFn validator2 = FormValidator.builder().required().isDateTime().build();
    expect("Field must be a valid date", validator2("10.02.1900"));
    expect(null, validator2("10/02/1900"));

    expect("Field must be a valid date", validator("As should this"));
    expect("Field can't be empty", validator(""));
    expect("Field can't be null", validator(null));
  });

  test('Custom function validators', () {
    String customErorr = "Number must be a multiple of 100!";

    ValidationFn validator = FormValidator.builder()
        .notNull(errorMessage: "Woah enter something!")
        .notEmpty()
        .isNumeric()
        // If it hits the custom we can assume the types will convert properly
        .custom((p0) => (p0 == null || (num.parse(p0) % 100) != 0) ? customErorr : null)
        .build();

    expect(null, validator("100"));
    expect(null, validator("1000"));
    expect(customErorr, validator("1"));
    expect(customErorr, validator("1.1001"));
    expect("Field must be a valid number", validator("This should fail"));
    expect("Field can't be empty", validator(""));
    expect("Woah enter something!", validator(null));
  });
}
