import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:provider/provider.dart';

class DatabaseFunctions {
  //  add user data to the database
  static Future<void> addUserData(Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userData["userId"])
        .set(userData);
  }

  // get user data from the database
  static Future<UserModel> getUserData(String userId, context) async {
    final DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    if (!documentSnapshot.exists) {
      UserModel userModel = UserModel(
          email: FirebaseAuth.instance.currentUser!.email!, userId: userId);
      await addUserData(userModel.toJson());
      Provider.of<AppData>(context, listen: false).setUserModel = userModel;
      return userModel;
    }
    Provider.of<AppData>(context, listen: false).setUserModel =
        UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  // update user data
  static Future<void> updateUserData(
      Map<String, dynamic> userData, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userData, SetOptions(merge: true));
  }

  // follow user
  static Future<void> followUser(
      String currentUserId, String followingUserId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .update({
      "following": FieldValue.arrayUnion([followingUserId])
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(followingUserId)
        .update({
      "followers": FieldValue.arrayUnion([currentUserId])
    });
  }

  // unfollow user
  Future<void> unFollowUser(
      String currentUserId, String followingUserId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .update({
      "following": FieldValue.arrayRemove([followingUserId])
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(followingUserId)
        .update({
      "followers": FieldValue.arrayRemove([currentUserId])
    });
  }

  // get metadata of my folllowing
  Future<List<UserModel>> getFollowingData(String userId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("following", arrayContains: userId)
        .get();
    return querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocumentSnapshot) =>
            UserModel.fromJson(
                queryDocumentSnapshot.data() as Map<String, dynamic>))
        .toList();
  }

  // get metadata of my followers
  Future<List<UserModel>> getFollowersData(String userId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("followers", arrayContains: userId)
        .get();
    return querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocumentSnapshot) =>
            UserModel.fromJson(
                queryDocumentSnapshot.data() as Map<String, dynamic>))
        .toList();
  }

  // is username available
  static Future<bool> isUsernameAvailable(String username) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // get post image list
  static Future<List<String>> getImages() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("content")
        .doc("post")
        .get();
    if (!documentSnapshot.exists) {
      return [];
    }
    List<String> images = List<String>.from(
        (documentSnapshot.data() as Map<String, dynamic>)["images"]);
    // shuffle the list
    images.shuffle();
    return images;
  }

  // get reel video list
  static Future<List<String>> getVideos() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("content")
        .doc("reels")
        .get();
    if (!documentSnapshot.exists) {
      return [];
    }
    List<String> videos = List<String>.from(
        (documentSnapshot.data() as Map<String, dynamic>)["videos"]);
    return videos;
  }

  // get all reels from the database
  static Future<List<ReelModel>> getAllReels() async {
    List<ReelModel> reels = [];
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("reels").get();
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      reels.add(ReelModel.fromMap(
          queryDocumentSnapshot.data() as Map<String, dynamic>));
    }
    return reels;
  }

  // get all posts from the database
  static Future<List<PostModel>> getAllPosts() async {
    List<PostModel> posts = [];
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("posts").get();
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      posts.add(PostModel.fromMap(
          queryDocumentSnapshot.data() as Map<String, dynamic>));
    }
    return posts;
  }
}
