import 'dart:io';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/user_model.dart';
import 'package:bonbon_mobile/validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
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
  bool rememberMe = false;
  String token = '';

  final box = GetStorage();

  void biometricLogin (UserModel userModel) async {
    // USE BIOMETRIC
    final auth = LocalAuthentication();
    List<BiometricType> availableBiometrics =
    await auth.getAvailableBiometrics();

    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        bool didAuthenticate = await auth.authenticate(localizedReason: 'Authenticate to login');
        if(didAuthenticate){
          userModel.logInWithToken(token);
        }

      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        bool didAuthenticate = await auth.authenticate(localizedReason: 'Authenticate to login');
        if(didAuthenticate){
          userModel.logInWithToken(token);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    token = box.read('token') ?? '';
    _email.text = box.read('email') ?? '';

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      UserModel user = Provider.of<UserModel>(context, listen: false);

      if(token.isNotEmpty){
        rememberMe = true;
        biometricLogin(user);
      }
    });
  }

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
                    validator: passwordValidation,
                    controller: _password,
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }, icon: Icon(!showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash)),
                    isPassword: !showPassword,
                  ),
                  CheckboxListTile(
                      value: rememberMe,
                      onChanged: (value){
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                      title: const Text('Keep Me Logged In'),
                    ),

                  ColorButtonWithLoading(onPressed: (start, end, state)  async {
                    if(state == ButtonState.Idle){
                      if(_formKey.currentState!.validate()) {
                        start();
                        await _user.logIn(email: _email.text, password: _password.text,rememberMe: rememberMe);
                        end();
                      }
                    }
                  }, label: 'Login'),
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


