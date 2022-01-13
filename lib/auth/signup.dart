import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/user_model.dart';
import 'package:bonbon_mobile/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool allowToProceed = false;
  bool showPassword = false;


  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * .80,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthInput(
                        icon: FontAwesomeIcons.userAlt,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Name',
                        controller: _name,
                        textCap: TextCapitalization.sentences,
                        validator: nameValidation,
                    ),
                    AuthInput(
                        icon: FontAwesomeIcons.envelope,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        controller: _email,
                        textCap: TextCapitalization.sentences,
                        validator: emailValidation
                    ),
                    AuthInput(
                      icon: FontAwesomeIcons.lock,
                      label: 'Password',
                      controller: _password,
                      validator: passwordValidation,
                      suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          icon: Icon(!showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash)),
                      isPassword: !showPassword,
                      onChanged: (value){
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
                      child: FlutterPwValidator(
                          width: 400,
                          height: 150,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          numericCharCount: 1,
                          specialCharCount: 1,
                          controller: _password,
                          onSuccess: (){
                            setState(() {
                              allowToProceed = true;
                            });
                          },
                      ),
                    ),
                    AuthInput(
                      icon: FontAwesomeIcons.lock,
                      label: 'Confirm Password',
                      controller: _confirm,
                      validator: passwordValidation,
                      isPassword: !showPassword,
                      onChanged: (value){
                        setState(() {});
                      },
                      suffixIcon: Icon(
                        FontAwesomeIcons.check,
                        size: 20,
                        color: _password.text == _confirm.text && _confirm.text.isNotEmpty ? Colors.green : Colors.grey,),
                    ),
                    ColorButtonWithLoading(onPressed: (start, end, state) async {
                      if(_formKey.currentState!.validate() && allowToProceed){
                        if(state == ButtonState.Idle){
                          start();
                          _user.signUp(
                              name: _name.text,
                              email: _email.text,
                              password: _password.text
                          );
                          end();
                        }
                      }
                    }, label: 'Sign Up'),
                    const Divider(thickness: 1.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(onPressed: (){
                           Navigator.pushNamed(context, '/login');
                        }, child: const Text('Login')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
