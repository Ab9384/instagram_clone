// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/database_function.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/home_post_chat_tab.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/widgets/custom_textfield.dart';
import 'package:instagram_clone/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  List<String> genderList = ['Select', 'Male', 'Female', 'Other'];
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AppData>(context).userModel;
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
                    'Let\'s get to know you better.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: fullNameController,
                      hintText: 'Full Name'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: dateOfBirthController,
                      readOnly: true,
                      onTap: () async {
                        // show cupertino date picker
                        await showCupertinoModalPopup<void>(
                          context: context,
                          builder: (_) {
                            final size = MediaQuery.of(context).size;
                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              height: size.height * 0.27,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime:
                                    dateOfBirthController.text.isEmpty
                                        ? DateTime.now()
                                        : dateFormat
                                            .parse(dateOfBirthController.text),
                                onDateTimeChanged: (value) {
                                  setState(() {
                                    dateOfBirthController.text =
                                        dateFormat.format(value).toString();
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      hintText: 'Date of Birth'),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: genderController,
                      hintText: 'Gender',
                      readOnly: true,
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (_) {
                            final size = MediaQuery.of(context).size;
                            return Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              height: size.height * 0.23,
                              child: CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 40,
                                // This sets the initial item.
                                scrollController: FixedExtentScrollController(
                                  initialItem: genderList.indexOf(
                                      genderController.text.isEmpty
                                          ? genderList[0]
                                          : genderController.text),
                                ),
                                // This is called when selected item is changed.
                                onSelectedItemChanged: (int selectedItem) {
                                  setState(() {
                                    genderController.text =
                                        genderList[selectedItem];
                                  });
                                },
                                children: List<Widget>.generate(
                                  genderList.length,
                                  (int index) {
                                    return Center(
                                      child: Text(
                                        genderList[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  PrimaryButton(
                      buttonText: 'Next',
                      showLoading: showLoading,
                      onPressed: () async {
                        if (fullNameController.text.isEmpty) {
                          ToastFunction.showRedToast(
                              context, 'Please enter your full name');
                          return;
                        }
                        if (dateOfBirthController.text.isEmpty) {
                          ToastFunction.showRedToast(
                              context, 'Please enter your date of birth');
                          return;
                        }
                        // age>15
                        if (DateTime.now().year -
                                dateFormat
                                    .parse(dateOfBirthController.text)
                                    .year <
                            15) {
                          ToastFunction.showRedToast(
                              context, 'You must be 15 years or older');
                          return;
                        }
                        if (genderController.text.isEmpty) {
                          ToastFunction.showRedToast(
                              context, 'Please enter your gender');
                          return;
                        }
                        if (genderController.text == 'Select') {
                          ToastFunction.showRedToast(
                              context, 'Please select your gender');
                          return;
                        }
                        setState(() {
                          showLoading = true;
                        });
                        userModel!.fullName = fullNameController.text;
                        userModel.dateOfBirth = dateOfBirthController.text;
                        userModel.gender = genderController.text;
                        try {
                          await DatabaseFunctions.updateUserData(
                              userModel.toJson(), userModel.userId!);
                          Provider.of<AppData>(context, listen: false)
                              .setUserModel = userModel;
                          setState(() {
                            showLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            showLoading = false;
                          });
                          debugPrint(e.toString());
                        }
                        NavigatorFunctions.navigateAndClearStack(
                            context, const HomePostChatTabScreen());
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
