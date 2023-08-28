import 'dart:convert';

import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/data/models/user/user_model.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_state.dart';
import 'package:ecommerce_app/presentation/screens/order/my_order_screen.dart';
import 'package:ecommerce_app/presentation/screens/user/edit_profile_screen.dart';
import 'package:ecommerce_app/presentation/widgets/link_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubits/user_cubit/user_cubit.dart';
import '../../../utils/CustomDecoration.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit,UserState>(
      builder: (context,state) {

        if(state is UserLoadingState){
          return Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(state is UserErrorState){
          return  Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        if(state is UserLoggedInState){
          return userProfile(state.userModel);
        }

        return Center(
          child: Text("An error occure"),
        );
      }
    );
  }

  Widget userProfile(UserModel userModel){
    return Container(
      decoration: CustomDecoration.setGradientBackgroundDecoration(),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: ( userModel.profilePicture != "")
                    ?
                // Image.network(
                //   userModel.profilePicture!,
                //   loadingBuilder:
                //       (context, child, loadingProgress) =>
                //   (loadingProgress == null)
                //       ? child
                //       : Image.asset(
                //     'lib/assets/images/avatar.png',
                //     width: 80,
                //     height: 80,
                //     fit: BoxFit.cover,
                //   ),
                //   errorBuilder: (context, error, stackTrace) =>
                //       Image.asset(
                //         'lib/assets/images/avatar.png',
                //         width: 80,
                //         height: 80,
                //         fit: BoxFit.cover,
                //       ),
                //   height: 100,
                //   width: 100,
                // )
                Image.memory(base64Decode(userModel.profilePicture!), fit: BoxFit.cover,height: 100,width: 100,)
                    : Image.asset(
                  'lib/assets/images/avatar.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Text("${userModel.fullName}",style: TextStyles.heading3,),
              Text("${userModel.email}",style: TextStyles.body2,),
              Text("${userModel.phoneNumber}",style: TextStyles.body2,),
              Text("${userModel.address}",style: TextStyles.body2,),
              Text("${userModel.city}",style: TextStyles.body2,),

              LinkButton(
                  onPressed: (){
                    Navigator.pushNamed(context, EditProfileScreen.routeName);
                  },
                  text: "Edit Profile"),

              const Divider(),

              ListTile(
                onTap: (){
                  Navigator.pushNamed(context, MyOrderScreen.routeName);
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(CupertinoIcons.cube_box_fill),
                title: Text("My Order",style: TextStyles.body1,),
              ),

              ListTile(
                onTap: (){
                  BlocProvider.of<UserCubit>(context).signOut();
                },
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.exit_to_app,color: Colors.red,),
                title: Text("Sign Out",style: TextStyles.body1.copyWith(color: Colors.red)),
              )


            ],
          )

        ],
      ),
    );
  }
}
