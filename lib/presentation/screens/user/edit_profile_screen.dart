

import 'dart:convert';
import 'dart:typed_data';

import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/data/models/user/user_model.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_state.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:ecommerce_app/presentation/widgets/primary_button.dart';
import 'package:ecommerce_app/presentation/widgets/primary_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

import '../../../logic/cubits/user_cubit/user_cubit.dart';
import '../../../utils/CustomDecoration.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static const routeName = "edit_profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final ImagePicker imgpicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("Edit Profile"),
            backgroundColor: AppColors.appBarColors,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state is UserLoadingState) {
            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is UserErrorState) {
            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: Center(
                child: Text(state.message),
              ),
            );
          }
          if (state is UserLoggedInState) {
            return editProfile(context, state.userModel);
          }

          return Center(
            child: Text("An error occure"),
          );
        }),
      ),
    );
  }
  void _showPicker({required BuildContext context,required UserModel userModel}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                   getImage(ImageSource.gallery,userModel);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                   getImage(ImageSource.camera,userModel);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img,UserModel userModel) async {
    final pickedFile = await imgpicker.pickImage(source: img, imageQuality: 50,);
    String? imagePath = "";
    imagePath = pickedFile?.path;
    File imageFile = File(imagePath!); //convert Path to File
    Uint8List imageBytes = await imageFile.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imageBytes);

    if(base64string != ""){
      // postData(userModel.sId!,base64string).then((value) async{
      //   if(value == true) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text("Profile pic Uploded"),
      //         backgroundColor: Colors.black,
      //       ),
      //     );
      //     userModel.profilePicture = base64string;
      //     await BlocProvider.of<UserCubit>(context).upDateUser(userModel);
      //   }else{
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text("Profile pic Not Uploded"),
      //         backgroundColor: Colors.black,
      //       ),
      //     );
      //   }
      // });

      bool success = await BlocProvider.of<UserCubit>(context).updateImageOfUser(userModel,base64string);
      if(success){
        Fluttertoast.showToast(
            msg: "Profile picture Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        Fluttertoast.showToast(
            msg: "Profile picture Not Uploaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

  Widget editProfile(BuildContext context, UserModel userModel) {
    return Container(
      decoration: CustomDecoration.setGradientBackgroundDecoration(),
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            margin: const EdgeInsets.only(
              // top: 20,
              left: 50,
              right: 50,
              // bottom: 5,
            ),
            child: Column(
              children: [
                // Align(
                //   alignment: Alignment.topRight,
                //   child: SizedBox(
                //     height: 20,
                //     width: 20,
                //     child: IconButton(
                //       icon: const Icon(Icons.edit),
                //       iconSize: 30,
                //       color: const Color.fromRGBO(116, 116, 116, 1),
                //       padding: const EdgeInsets.all(0),
                //       onPressed: () {
                //         _showPicker(context: context,userModel: userModel);
                //       },
                //     ),
                //   ),
                // ),
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
            IconButton(
              onPressed: (){
                _showPicker(context: context,userModel: userModel);
              },
              icon: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.blue,
                size: 30,
              ),
            )
              ],
            ),
          ),
          GapWidget(
            size: -5,
          ),
          Text(
            "Personal Details",
            style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          GapWidget(
            size: -10,
          ),
          PrimaryTextField(
              initialValue: userModel.fullName,
              onChanged: (value) {
                userModel.fullName = value;
              },
              labelText: "Full Name"),
          GapWidget(),
          PrimaryTextField(
              initialValue: userModel.phoneNumber,
              onChanged: (value) {
                userModel.phoneNumber = value;
              },
              labelText: "Phone Number"),
          GapWidget(
            size: 20,
          ),
          Text(
            "Address",
            style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          GapWidget(
            size: -5,
          ),
          PrimaryTextField(
              initialValue: userModel.address,
              onChanged: (value) {
                userModel.address = value;
              },
              labelText: "Address"),
          GapWidget(),
          PrimaryTextField(
              initialValue: userModel.city,
              onChanged: (value) {
                userModel.city = value;
              },
              labelText: "City"),
          GapWidget(),
          PrimaryTextField(
              initialValue: userModel.state,
              onChanged: (value) {
                userModel.state = value;
              },
              labelText: "State"),
          GapWidget(),
          PrimaryButton(
            onPressed: () async {
              bool success =
              await BlocProvider.of<UserCubit>(context).upDateUser(userModel);
              if (success) {
                Fluttertoast.showToast(
                    msg: "Profile Saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pop(context);
              }
            },
            text: "Save",
          )
        ],
      ),
    );
  }
}


