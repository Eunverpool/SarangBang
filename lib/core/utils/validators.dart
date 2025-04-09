import 'package:form_field_validator/form_field_validator.dart';

class Validators {
  /// Email Validator
  static final email = EmailValidator(errorText: 'Enter a valid email address');

  /// Password Validator
  static final password = MultiValidator([
    RequiredValidator(errorText: '패스워드를 입력하세요.'),
    MinLengthValidator(8, errorText: '패스워드는 최소 8자리 이상이여야 합니다.'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character')
  ]);

  /// Required Validator with Optional Field Name
  static RequiredValidator requiredWithFieldName(String? fieldName) =>
      RequiredValidator(errorText: '${fieldName}를 입력하세요.');

  /// Plain Required Validator
  static final required = RequiredValidator(errorText: 'Field is required');
}
