// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/auth_function.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/functions/regex_function.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:instagram_clone/screens/deciding_screen.dart';
import 'package:instagram_clone/utils/app_colors.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:instagram_clone/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  bool showLoading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: !showLoading,
        child: SafeArea(
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
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                alignment: Alignment.center,
                                width: 150,
                              ),
                              const SizedBox(height: 40),
                              // username
                              CustomTextField(
                                  controller: emailController,
                                  hintText: 'Email'),
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
                              const SizedBox(height: 20),
                              // confirm password
                              CustomTextField(
                                  controller: confirmPasswordController,
                                  hintText: 'Confirm Password',
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
                              const SizedBox(height: 40),
                              PrimaryButton(
                                  showLoading: showLoading,
                                  buttonText: 'Sign up',
                                  onPressed: () async {
                                    if (!RegExFunction.isEmailValid(
                                        emailController.text)) {
                                      ToastFunction.showRedToast(context,
                                          'Please enter a valid email');
                                      return;
                                    }
                                    if (!RegExFunction.isPasswordValid(
                                        passwordController.text)) {
                                      ToastFunction.showRedToast(context,
                                          'Please should be 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character');
                                      return;
                                    }
                                    if (passwordController.text !=
                                        confirmPasswordController.text) {
                                      ToastFunction.showRedToast(
                                          context, 'Passwords do not match');
                                      return;
                                    }
                                    // if all the fields are valid
                                    setState(() {
                                      showLoading = true;
                                    });

                                    bool isSignedUp = await AuthFunction()
                                        .signUpWithEmailAndPassword(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                            context);

                                    setState(() {
                                      showLoading = false;
                                    });
                                    if (isSignedUp) {
                                      NavigatorFunctions.navigateAndClearStack(
                                          context, const DecidingScreen());
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
                              // sign up with google
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
                                      Text('Sign up with Google',
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
                      const Text("Already have an account? "),
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: const Size(0, 0)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Log in',
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
      ),
    );
  }
}
