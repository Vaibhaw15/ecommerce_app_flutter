import 'dart:convert';

import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_state.dart';
import 'package:ecommerce_app/logic/cubits/category_cubit/category_state.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_state.dart';
import 'package:ecommerce_app/presentation/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/presentation/screens/home/category_screen.dart';
import 'package:ecommerce_app/presentation/screens/home/profile_screen.dart';
import 'package:ecommerce_app/presentation/screens/home/user_feed_screen.dart';
import 'package:ecommerce_app/presentation/screens/splash/splash_screen.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user/user_model.dart';
import '../../../logic/cubits/category_cubit/category_cubit.dart';
import '../../../logic/cubits/category_product_cubit/category_product_cubit.dart';
import '../../../logic/cubits/category_product_cubit/category_product_state.dart';
import '../../../utils/CustomDecoration.dart';
import '../../widgets/product_ListView.dart';
import '../order/my_order_screen.dart';
import '../product/category_product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> screens = [UserFeedScreen(), CategoryScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOutState) {
          Navigator.pushReplacementNamed(context, SplashScreen.routeName);
        }
      },
      child: Scaffold(
        drawer: _createDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
          child: Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: AppBar(
              centerTitle: true,
              title:  BlocBuilder<UserCubit,UserState>(
                builder: (context,state) {
                  if(state is UserLoggedInState) {
                    return Text("Hi ${state.userModel.fullName!}");
                  }
                  return const Text("Ecommerce App");
                }
              ),
              actions: [
                IconButton(onPressed: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }, icon: BlocBuilder<CartCubit, CartState>(
                    builder: (context, state) {
                  return Badge(
                    label: Text("${state.items.length}"),
                    isLabelVisible: (state is CartLoadingState) ? false : true,
                    child: Icon(CupertinoIcons.cart_fill),
                  );
                })),
              ],
              backgroundColor: AppColors.appBarColors,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
            ),
          ),
        ),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.red,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Categories"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ],
        ),
      ),
    );
  }
}

Widget _createDrawer() {
  return BlocBuilder<CategoryCubit, CategoryState>(
    builder: (context, state) {
      if (state is CategoryInitialState) {
        debugPrint("initial state");
        return Container();
      } else if (state is CategoryLoadedState) {
        return drawer(context, state);
      }if (state is CategoryLoadingState) {
        return Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return const Center(
        child: Text("No results found"),
      );
    },
  );
}


Widget drawer(BuildContext context, CategoryLoadedState state) {
  return Drawer(
    child: Container(
      decoration: CustomDecoration.setGradientBackgroundDecoration(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
          Container(
            height: MediaQuery.of(context).size.height *0.13,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color(0XFF00E696),
                borderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(15))),
          child: DrawerHeader(
            child: Row(
              children: [
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is UserLoggedInState) {
                    UserModel user = state.userModel;
                    return Row(
                      children: [
                        ClipOval(
                          child: ( user.profilePicture != "")
                              ?
                          // Image.network(
                          //   user.profilePicture!,
                          //   loadingBuilder:
                          //       (context, child, loadingProgress) =>
                          //   (loadingProgress == null)
                          //       ? child
                          //       : Image.asset(
                          //     'lib/assets/images/avatar.png',
                          //     width: 50,
                          //     height: 50,
                          //   ),
                          //   errorBuilder: (context, error, stackTrace) =>
                          //       Image.asset(
                          //         'lib/assets/images/avatar.png',
                          //         width: 50,
                          //         height: 50,
                          //       ),
                          //   height: 50,
                          //   width: 50,
                          // )
                          Image.memory(base64Decode(state.userModel.profilePicture!), fit: BoxFit.cover,height: 70,width: 70,)
                              : Image.asset(
                            'lib/assets/images/avatar.png',
                            width: MediaQuery.of(context).size.width *0.2,
                            height: MediaQuery.of(context).size.height *0.2,
                          ),
                        ),
                        GapWidget(),
                        Text("Hi ${user.fullName}!",style: TextStyles.heading3.copyWith(fontSize:20),),
                      ],
                    );
                  }
                  return SizedBox();
                }),
                // ClipOval(
                //   child: ( profilePic != "")
                //       ? Image.network(
                //     profilePic,
                //     loadingBuilder:
                //         (context, child, loadingProgress) =>
                //     (loadingProgress == null)
                //         ? child
                //         : Image.asset(
                //       'lib/assets/images/avatar.png',
                //       width: 50,
                //       height: 50,
                //     ),
                //     errorBuilder: (context, error, stackTrace) =>
                //         Image.asset(
                //           'lib/assets/images/avatar.png',
                //           width: 50,
                //           height: 50,
                //         ),
                //     height: 50,
                //     width: 50,
                //   )
                //       : Image.asset(
                //     'lib/assets/images/avatar.png',
                //     width: 50,
                //     height: 50,
                //   ),
                // ),
                // Expanded(child: Text("Welcome!",style: TextStyles.heading2,)),
              ],
            ),
          ),),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments: category);
                    },
                    leading: const Icon((Icons.category)),
                    title: Text("${category.title}"),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(height: 1,color: Colors.black,thickness: 1,),
            ),

           // GapWidget(size: MediaQuery.of(context).size.height * 0.23,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: ListTile(
                onTap: (){
                  Navigator.pushNamed(context, MyOrderScreen.routeName);
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(CupertinoIcons.cube_box_fill),
                title: Text("My Order",style: TextStyles.body1,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: ListTile(
                onTap: (){
                  BlocProvider.of<UserCubit>(context).signOut();
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.exit_to_app,color: Colors.brown,),
                title: Text("Sign Out",style: TextStyles.body1.copyWith(color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
