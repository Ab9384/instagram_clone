// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/database_function.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/functions/regex_function.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/profile/setup_profile_screen.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:instagram_clone/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class SetUsernameScreen extends StatefulWidget {
  const SetUsernameScreen({super.key});

  @override
  State<SetUsernameScreen> createState() => _SetUsernameScreenState();
}

class _SetUsernameScreenState extends State<SetUsernameScreen> {
  final TextEditingController usernameController = TextEditingController();
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<AppData>(context).userModel!;
    return Scaffold(
        body: SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                  const SizedBox(height: 20),
                  const Text(
                    'Choose a username for your account. You can always change it later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      hintText: 'Username'),
                  const SizedBox(
                    height: 40,
                  ),
                  PrimaryButton(
                      showLoading: showLoading,
                      buttonText: 'Next',
                      onPressed: () async {
                        if (!RegExFunction.isUsernameValid(
                            usernameController.text)) {
                          ToastFunction.showRedToast(
                              context, 'Invalid username');
                          return;
                        }
                        setState(() {
                          showLoading = true;
                        });
                        bool validUsername =
                            await DatabaseFunctions.isUsernameAvailable(
                                usernameController.text);

                        if (validUsername) {
                          userModel.username = usernameController.text;
                          try {
                            await DatabaseFunctions.updateUserData(
                                userModel.toJson(), userModel.userId!);

                            setState(() {
                              showLoading = false;
                            });
                            Provider.of<AppData>(context, listen: false)
                                .setUserModel = userModel;
                            NavigatorFunctions.navigateAndClearStack(
                                context, const SetupProfileScreen());
                          } catch (e) {
                            setState(() {
                              showLoading = false;
                            });
                            debugPrint("error username: ${e.toString()}");
                            ToastFunction.showRedToast(
                                context, 'Something went wrong');
                          }
                        } else {
                          setState(() {
                            showLoading = false;
                          });
                          ToastFunction.showRedToast(
                              context, 'Username already taken');
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
