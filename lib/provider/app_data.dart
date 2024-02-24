import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/models/user_model.dart';

class AppData extends ChangeNotifier {
  UserModel? userModel;

  set setUserModel(UserModel userModel) {
    this.userModel = userModel;
    notifyListeners();
  }

  // ----------------- Post -----------------
  List<PostModel> postList = [];

  set setPostList(List<PostModel> postList) {
    this.postList = postList;
    notifyListeners();
  }

  // ----------------- Reels -----------------
  List<ReelModel> reelsList = [];

  set setReelsList(List<ReelModel> reelsList) {
    this.reelsList = reelsList;
    notifyListeners();
  }

  // ----------------- Stories -----------------
  List<StoryModel> storiesList = [];

  set setStoriesList(List<StoryModel> storiesList) {
    this.storiesList = storiesList;
    notifyListeners();
  }

  // ----------------- Image List -----------------
  List<String> imageList = [];

  set setImageList(List<String> imageList) {
    this.imageList = imageList;
    notifyListeners();
  }

  // ----------------- Video List -----------------
  List<String> videoList = [];

  set setVideoList(List<String> videoList) {
    this.videoList = videoList;
    notifyListeners();
  }
}
