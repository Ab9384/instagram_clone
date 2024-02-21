import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
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

  // post image list
  List<String> postImageList = [];

  set setPostImageList(List<String> postImageList) {
    this.postImageList = postImageList;
    notifyListeners();
  }

  // reel video list
  List<String> reelVideoList = [];

  set setReelVideoList(List<String> reelVideoList) {
    this.reelVideoList = reelVideoList;
    notifyListeners();
  }
}
