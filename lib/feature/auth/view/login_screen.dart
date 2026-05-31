import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:shoply/core/common/widget/custom_form_text_fiel.dart';
import 'package:shoply/core/dialogs/app_dialogs.dart';
import 'package:shoply/core/dialogs/app_toasts.dart';
import 'package:shoply/core/utils/validator_functions.dart';
import 'package:shoply/feature/app_section/app_section.dart';
import 'package:shoply/feature/auth/controller/login/login_cubit.dart';
import 'package:shoply/feature/auth/controller/register/register_cubit.dart';
import 'package:shoply/feature/auth/view/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          AppDialogs.showLoadingDialog(context);
        }

        if (state is LoginError) {
          Navigator.pop(context);
          AppToast.showToast(
            context: context,
            title: 'Error',
            description: state.messageError,
            type: ToastificationType.error,
          );
        }

        if (state is LoginSuccess) {
          Navigator.pop(context);
          AppToast.showToast(
            context: context,
            title: 'Success',
            description: 'Login successful',
            type: ToastificationType.success,
          );
          Navigator.pushReplacementNamed(
            context,
            AppSection.routeName,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Login",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xff1F1F1F),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  controller: emailController,
                  validator: Validator.validateEmail,
                  hintText: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  action: TextInputAction.next,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                CustomTextFormField(
                  controller: passwordController,
                  validator: Validator.validatePassword,
                  hintText: "Enter your password",
                  isPassword: true,
                  keyboardType: TextInputType.emailAddress,
                  action: TextInputAction.done,
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  color: const Color(0xff212121),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await context.read<LoginCubit>().login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                    }
                  },
                  child: const Text(
                    "Login",
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff6E6A7C),
                    ),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff212121),
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => RegisterCubit(),
                                  child: RegisterScreen(),
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
