import 'package:bonbon_mobile/Auth/functionality.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/user_model.dart';
import 'package:bonbon_mobile/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    UserModel _user = Provider.of<UserModel>(context, listen: false);

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(child: SingleChildScrollView(
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
                    label: 'Email',
                    controller: _email,
                    textCap: TextCapitalization.sentences,
                    validator: emailValidation
                  ),
                  AuthInput(
                    icon: FontAwesomeIcons.lock,
                    label: 'Password',
                    controller: _password,
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }, icon: Icon(!showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash)),
                    isPassword: !showPassword,
                  ),
                  ColorButton(onPressed: (){
                    logIn(
                        validate: _formKey.currentState!.validate(),
                        email: _email.text,
                        password: _password.text,
                        saveUser: _user.saveUser,
                        context: context
                    );
                  }, label: const Text('Login')),
                  const Divider(thickness: 1.5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, '/signup');
                      }, child: const Text('Sign up')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}


