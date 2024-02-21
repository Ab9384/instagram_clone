// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/auth_function.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:instagram_clone/screens/authentication/signup_screen.dart';
import 'package:instagram_clone/screens/deciding_screen.dart';
import 'package:instagram_clone/utils/app_colors.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:instagram_clone/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ExtendedImage.asset(
                              'assets/logo/text_logo.png',
                              color: Theme.of(context).colorScheme.brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              alignment: Alignment.center,
                              width: 150,
                            ),
                            const SizedBox(height: 40),
                            // username
                            CustomTextField(
                                controller: emailController, hintText: 'Email'),
                            const SizedBox(height: 20),
                            // password
                            CustomTextField(
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: !isPasswordVisible,
                                suffix: isPasswordVisible
                                    ? IconButton(
                                        icon: const Icon(
                                            Icons.visibility_rounded,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                            Icons.visibility_off_rounded,
                                            color: Colors.grey),
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        })),
                            // forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text('Forgot password?',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            PrimaryButton(
                                showLoading: isLoading,
                                buttonText: 'Log in',
                                onPressed: () async {
                                  if (emailController.text.isEmpty) {
                                    ToastFunction.showRedToast(
                                        context, 'Email is required');
                                    return;
                                  }
                                  if (passwordController.text.isEmpty) {
                                    ToastFunction.showRedToast(
                                        context, 'Password is required');
                                    return;
                                  }
                                  setState(() {
                                    isLoading = true;
                                  });
                                  // call login api
                                  try {
                                    await AuthFunction()
                                        .signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    NavigatorFunctions.navigateAndClearStack(
                                        context, const DecidingScreen());
                                  } catch (e) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ToastFunction.showRedToast(
                                        context, e.toString());
                                  }
                                }),
                            const SizedBox(height: 20),
                            // or divider
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      Divider(color: AppColors.instagramGrey),
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('OR',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.instagramGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // facebook login
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ExtendedImage.asset(
                                        'assets/logo/google.png',
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.contain),
                                    const SizedBox(width: 10),
                                    Text('Log in with Google',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color)),
                                  ],
                                ))
                          ]),
                    ),
                  ),
                ),
                // sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          minimumSize: const Size(0, 0)),
                      onPressed: () {
                        NavigatorFunctions.navigateTo(
                            context, const SignUpScreen());
                      },
                      child: Text('Sign up.',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
