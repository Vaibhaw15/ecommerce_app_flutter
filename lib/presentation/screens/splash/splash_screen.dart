import 'dart:async';

import 'package:ecommerce_app/presentation/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/user_cubit/user_cubit.dart';
import '../../../logic/cubits/user_cubit/user_state.dart';
import '../../../utils/CustomDecoration.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void goToNextScreen() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLoggedInState) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else if (userState is UserLoggedOutState) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else if (userState is UserErrorState) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(microseconds: 100), () {
      goToNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit,UserState>(
      listener: (context,state){
        goToNextScreen();
      },
      child:  Scaffold(
        body: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
