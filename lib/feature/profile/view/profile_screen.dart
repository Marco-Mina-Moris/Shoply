import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoply/core/common/widget/custom_form_text_fiel.dart';
import 'package:shoply/core/dialogs/app_dialogs.dart';
import 'package:shoply/core/dialogs/app_toasts.dart';
import 'package:shoply/core/model/request/update_user_request.dart';
import 'package:shoply/core/utils/validator_functions.dart';
import 'package:shoply/feature/profile/controller/profile_cubit.dart';
import 'package:shoply/core/storage_helper/app_shared_preference_helper.dart';
import 'package:shoply/feature/auth/view/login_screen.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileLoading) {
            // تغيير من GetProfileLoading
            AppDialogs.showLoadingDialog(context);
          }
          if (state is UpdateProfileSuccess) {
            Navigator.pop(context);
            AppToast.showToast(
              context: context,
              title: 'Success',
              description: 'Profile updated successfully',
              type: ToastificationType.success,
            );
          }
          if (state is UpdateProfileError) {
            Navigator.pop(context);
            AppToast.showToast(
              context: context,
              title: 'Error',
              description: state.errorMessage,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is GetProfileSuccess) {
            var cubit = context.read<ProfileCubit>();

            // تعيين القيم الحالية للـ controllers
            nameController.text = cubit.user.name ?? '';
            passwordController.text = cubit.user.password ?? '';
            emailController.text = cubit.user.email ?? '';

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: cubit.localAvatarPath != null &&
                                      cubit.localAvatarPath!.isNotEmpty &&
                                      File(cubit.localAvatarPath!).existsSync()
                                  ? FileImage(File(cubit.localAvatarPath!))
                                      as ImageProvider
                                  : (cubit.user.avatar != null &&
                                          cubit.user.avatar!.isNotEmpty
                                      ? NetworkImage(cubit.user.avatar!)
                                          as ImageProvider
                                      : const NetworkImage(
                                          'https://cdn-icons-png.flaticon.com/512/149/149071.png')),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _showImageSourceActionSheet(context, cubit),
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xff212121),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Name",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: nameController,
                      validator: Validator.validateName,
                      hintText: "Enter your Name",
                      keyboardType: TextInputType.name,
                      action: TextInputAction.next,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: emailController,
                      validator: Validator.validateEmail,
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      action: TextInputAction.next,
                      enable: false,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 5),
                    CustomTextFormField(
                      controller: passwordController,
                      validator: Validator.validatePassword,
                      hintText: "Enter your password",
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      action: TextInputAction.done,
                    ),
                    SizedBox(height: 30),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await cubit.updateProfile(
                            UpdateUserRequest(
                              name: nameController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                      color: Color(0xff212121),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Error loading profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state is GetProfileError ? state.errorMessage : "Something went wrong",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      final token = SharedPreferencesHelper.getData(key: 'accessToken') as String? ?? '';
                      context.read<ProfileCubit>().getDataProfile(token);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Try Again"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff212121),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () async {
                      await SharedPreferencesHelper.removeData(key: 'accessToken');
                      await SharedPreferencesHelper.removeData(key: 'refreshToken');
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text("Logout", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context, ProfileCubit cubit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xff212121)),
                title: const Text('Pick From Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    cubit.updateLocalAvatar(image.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xff212121)),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    cubit.updateLocalAvatar(image.path);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
