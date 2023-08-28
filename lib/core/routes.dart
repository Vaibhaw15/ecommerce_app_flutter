import 'package:ecommerce_app/data/models/category/category_model.dart';
import 'package:ecommerce_app/data/models/product/product_model.dart';
import 'package:ecommerce_app/logic/cubits/category_product_cubit/category_product_cubit.dart';
import 'package:ecommerce_app/presentation/screens/auth/login_screen.dart';
import 'package:ecommerce_app/presentation/screens/auth/providers/login_provider.dart';
import 'package:ecommerce_app/presentation/screens/auth/providers/signup_provider.dart';
import 'package:ecommerce_app/presentation/screens/auth/signup_screen.dart';
import 'package:ecommerce_app/presentation/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/presentation/screens/home/allProductScreen.dart';
import 'package:ecommerce_app/presentation/screens/home/home_screen.dart';
import 'package:ecommerce_app/presentation/screens/order/my_order_screen.dart';
import 'package:ecommerce_app/presentation/screens/order/order_details_screen.dart';
import 'package:ecommerce_app/presentation/screens/order/order_placed_screen.dart';
import 'package:ecommerce_app/presentation/screens/order/provider/order_details_provider.dart';
import 'package:ecommerce_app/presentation/screens/product/category_product_screen.dart';
import 'package:ecommerce_app/presentation/screens/product/product_details_screen.dart';
import 'package:ecommerce_app/presentation/screens/splash/splash_screen.dart';
import 'package:ecommerce_app/presentation/screens/user/edit_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LoginProvider(context),
                child: const LoginScreen()));

      case SignupScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => SignupProvider(context),
                child: const SignupScreen()));

      case HomeScreen.routeName:
        return CupertinoPageRoute(builder: (context) => HomeScreen());

      case SplashScreen.routeName:
        return CupertinoPageRoute(builder: (context) => SplashScreen());

      case ProductDetailsScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ProductDetailsScreen(
                  productModel: settings.arguments as ProductModel,
                ));

      case CartScreen.routeName:
        return CupertinoPageRoute(builder: (context) => CartScreen());

      case CategoryProductScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => BlocProvider(
                create: (context) =>
                    CategoryProductCubit(settings.arguments as CategoryModel),
                child: CategoryProductScreen()));

      case EditProfileScreen.routeName:
        return CupertinoPageRoute(builder: (context) => EditProfileScreen());

      case AllProductScreen.routeName:
        return CupertinoPageRoute(builder: (context) => AllProductScreen());

      case OrderDetailsScreen.routeName:
        return CupertinoPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => OrderDetailsProvider(),
                child: OrderDetailsScreen()));

      case OrderPlacedScreen.routeName:
        return CupertinoPageRoute(builder: (context) => OrderPlacedScreen());

      case MyOrderScreen.routeName:
        return CupertinoPageRoute(builder: (context) => MyOrderScreen());

      default:
        return null; //404
    }
  }
}
