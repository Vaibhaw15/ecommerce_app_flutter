import 'package:ecommerce_app/presentation/screens/auth/login_screen.dart';
import 'package:ecommerce_app/presentation/screens/auth/providers/signup_provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../../utils/CustomDecoration.dart';
import '../../widgets/gao_widget.dart';
import '../../widgets/link_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  static const String routeName = "signup";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    return Scaffold(
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
                        "Create Account",
                        style: TextStyles.heading2,
                      ),
                    ),
                    GapWidget(
                      size: -10,
                    ),
                    (provider.error != "")
                        ? Text(
                            provider.error,
                            style: const TextStyle(color: Colors.red),
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
                    GapWidget(),
                    PrimaryTextField(
                      controller: provider.cpasswordController,
                      labelText: "Confirm Password",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Confirm your Password";
                        }
                        if (value.trim() != provider.passwordController.text.trim()) {
                          return "Password do not match";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    GapWidget(),
                    PrimaryButton(
                      onPressed: provider.createAccount,
                      text: (provider.isLoading) ? "..." : "Create Account",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
                        GapWidget(),
                        LinkButton(
                          text: "Log In",
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
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
    );
  }
}
