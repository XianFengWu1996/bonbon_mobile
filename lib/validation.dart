import 'package:profanity_filter/profanity_filter.dart';
import 'package:validators/validators.dart';

String? emailValidation(String? email){
  if(email == null || email.isEmpty){
    return 'Email can not be empty';
  }

  if(!isEmail(email)){
    return 'Please use a valid email';
  }

  return null;
}

String? passwordValidation(String? password){
  if(password == null || password.isEmpty){
    return 'Password can not be empty';
  }

  return null;
}

String? nameValidation(String? name){
  if(name == null || name.isEmpty){
    return 'Name can not be empty';
  }

  if(ProfanityFilter().hasProfanity(name)){
    return 'No profanity words allow';
  }
}