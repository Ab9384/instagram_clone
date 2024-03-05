import 'dart:math';

import 'package:custom_qr_generator/colors/color.dart';
import 'package:custom_qr_generator/options/colors.dart';
import 'package:custom_qr_generator/options/options.dart';
import 'package:custom_qr_generator/options/shapes.dart';
import 'package:custom_qr_generator/qr_painter.dart';
import 'package:custom_qr_generator/shapes/ball_shape.dart';
import 'package:custom_qr_generator/shapes/frame_shape.dart';
import 'package:custom_qr_generator/shapes/pixel_shape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/utils/app_colors.dart';
import 'package:provider/provider.dart';

class ShareProfileScreen extends StatefulWidget {
  const ShareProfileScreen({super.key});

  @override
  State<ShareProfileScreen> createState() => _ShareProfileScreenState();
}

class _ShareProfileScreenState extends State<ShareProfileScreen> {
  Gradient? gradient;
  @override
  void initState() {
    gradient = AppColors.gradients[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<AppData>(context).userModel!;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            int length = AppColors.gradients.length;
            gradient = AppColors.gradients[Random().nextInt(length - 1) + 1];
          });
        },
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: gradient,
            ),
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Share Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      // height: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: CustomPaint(
                              painter: QrPainter(
                                  data: "Welcome to Flutter",
                                  options: QrOptions(
                                      shapes: const QrShapes(
                                          darkPixel: QrPixelShapeCircle(),
                                          lightPixel: QrPixelShapeCircle(),
                                          frame: QrFrameShapeRoundCorners(
                                              cornerFraction: .25),
                                          ball: QrBallShapeRoundCorners(
                                              cornerFraction: .7)),
                                      colors: QrColors(
                                          dark: QrColorLinearGradient(
                                              colors: gradient!.colors
                                                  .sublist(0, 2),
                                              orientation: GradientOrientation
                                                  .leftDiagonal)))),
                              size: const Size(200, 200),
                            ),
                          ),
                          Text(
                            '@ ${userModel.username}',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = gradient!.createShader(
                                      const Rect.fromLTWH(
                                          0.0, 0.0, 200.0, 70.0))),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.instagramGrey),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.share,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Share',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // copy link
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.instagramGrey),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.link,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Copy Link',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              )
            ])),
      ),
    );
  }
}
