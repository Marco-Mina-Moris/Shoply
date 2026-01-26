import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply/core/common/widget/custom_form_text_fiel.dart';
import 'package:shoply/core/dialogs/app_dialogs.dart';
import 'package:shoply/core/dialogs/app_toasts.dart';
import 'package:shoply/core/model/request/update_user_request.dart';
import 'package:shoply/core/utils/validator_functions.dart';
import 'package:shoply/feature/profile/controller/profile_cubit.dart';
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
                    SizedBox(height: 30),
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
            child: Text(
              "Error loading profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
