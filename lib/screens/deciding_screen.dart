import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/firebase/auth_function.dart';
import 'package:instagram_clone/firebase/database_function.dart';
import 'package:instagram_clone/functions/navigator_function.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/screens/authentication/login_screen.dart';
import 'package:instagram_clone/screens/home_post_chat_tab.dart';
import 'package:instagram_clone/screens/profile/set_username_screen.dart';
import 'package:instagram_clone/screens/profile/setup_profile_screen.dart';
import 'package:provider/provider.dart';

class DecidingScreen extends StatefulWidget {
  const DecidingScreen({super.key});

  @override
  State<DecidingScreen> createState() => _DecidingScreenState();
}

class _DecidingScreenState extends State<DecidingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      decideScreen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CupertinoActivityIndicator(
        radius: 15,
        animating: true,
        key: Key('deciding_screen_activity_indicator'),
      )),
    );
  }

  decideScreen(context) async {
    User? user = AuthFunction().getCurrentUser();
    bool isLoggedIn = user != null;
    if (isLoggedIn) {
      UserModel userModel =
          await DatabaseFunctions.getUserData(user.uid, context);
      if (userModel.username == null) {
        // username screen
        NavigatorFunctions.navigateAndClearStack(
            context, const SetUsernameScreen());
      } else if (userModel.fullName == null) {
        // username screen
        NavigatorFunctions.navigateAndClearStack(
            context, const SetupProfileScreen());
      } else {
        // home screen
        List<String> imageList = await DatabaseFunctions.getImages();
        List<String> videoList = await DatabaseFunctions.getVideos();
        List<PostModel> posts = await DatabaseFunctions.getAllPosts();
        List<ReelModel> reels = await DatabaseFunctions.getAllReels();
        debugPrint('postImageList: ${posts.length}');
        debugPrint('reelVideoList: ${reels.length}');
        posts.shuffle();
        reels.shuffle();
        Provider.of<AppData>(context, listen: false).setPostList = posts;
        Provider.of<AppData>(context, listen: false).setReelsList = reels;
        Provider.of<AppData>(context, listen: false).imageList = imageList;
        Provider.of<AppData>(context, listen: false).videoList = videoList;
        NavigatorFunctions.navigateAndClearStack(
            context, const HomePostChatTabScreen());
      }
    } else {
      NavigatorFunctions.navigateAndClearStack(context, const LoginScreen());
    }
  }
}
