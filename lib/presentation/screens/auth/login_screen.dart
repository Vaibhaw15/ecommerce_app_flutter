import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_state.dart';
import 'package:ecommerce_app/presentation/screens/auth/providers/login_provider.dart';
import 'package:ecommerce_app/presentation/screens/auth/signup_screen.dart';
import 'package:ecommerce_app/presentation/screens/home/home_screen.dart';
import 'package:ecommerce_app/presentation/screens/splash/splash_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../utils/CustomDecoration.dart';
import '../../widgets/gao_widget.dart';
import '../../widgets/link_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedInState) {
          Navigator.popUntil(context,(route) => route.isFirst);
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: AppBar(
              centerTitle: true,
              title: const Text("Ecommerce App"),
              backgroundColor: AppColors.appBarColors,
              shape:  const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          padding: EdgeInsets.only(top: 20,left: 10,right: 10),
          child: SafeArea(
            child: Container(
              height: 450,
              child: Card(
                margin: EdgeInsets.only(top: 30),
                color: Colors.white60,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
          ),
                child: Form(
                  key: provider.formKey,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Text(
                          "Welcome!",
                          style: TextStyles.heading4,
                        ),
                      ),
                      GapWidget(
                        size: -10,
                      ),
                      (provider.error != "")
                          ? Text(
                              provider.error,
                              style: TextStyle(color: Colors.red.shade800),
                            )
                          : const SizedBox(),
                      GapWidget(),
                      PrimaryTextField(
                          controller: provider.emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email address is required";
                            }
                            if (!EmailValidator.validate(value.trim())) {
                              return "Invalid email address";
                            }
                            return null;
                          },
                          labelText: "Email Address"),
                      GapWidget(),
                      PrimaryTextField(
                        controller: provider.passwordController,
                        labelText: "Password",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LinkButton(
                            text: "Forgot password",
                            onPressed: () {},
                          ),
                        ],
                      ),
                      GapWidget(),
                      PrimaryButton(
                        onPressed: provider.logIn,
                        text: (provider.isLoading) ? "..." : "Log In",
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          GapWidget(),
                          LinkButton(
                            text: "Sign Up",
                            onPressed: () {
                              Navigator.pushNamed(context, SignupScreen.routeName);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
