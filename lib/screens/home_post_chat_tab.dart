import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/functions/helper_functions.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/provider/settings.dart';
import 'package:instagram_clone/screens/home/landing_screen.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class HomePostChatTabScreen extends StatefulWidget {
  const HomePostChatTabScreen({super.key});

  @override
  State<HomePostChatTabScreen> createState() => _HomePostChatTabScreenState();
}

class _HomePostChatTabScreenState extends State<HomePostChatTabScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    tabController = TabController(initialIndex: 1, length: 3, vsync: this);
    super.initState();
  }

  bool showLoading = false;
  List<XFile> imageList = [];
  FilePickerResult? videoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          physics:
              Provider.of<SettingsProvider>(context).currentHomeScreenIndex != 0
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
          controller: tabController,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: PrimaryButton(
                buttonText: 'Add reels',
                showLoading: showLoading,
                onPressed: () async {
                  // await pickImage();
                  // await uploadImage();

                  // await pickVideo();
                  // await uploadVideo();

                  // await readImage();

                  // addDummyPost();
                  // addDummyReels();
                },
              ),
            )),
            const LandingScreen(),
            const Center(child: Text('Chats')),
          ]),
    );
  }

  // // pick image from gallery multiple
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      imageList = images;
    });
  }

  // upload image to firebase storage and url to firestore
  Future<void> uploadImage() async {
    setState(() {
      showLoading = true;
    });
    // upload image to firebase storage
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> imageUrlList = [];

    for (var image in imageList) {
      String imageName = image.path.split('/').last; // Extracting image name
      UploadTask uploadTask =
          storage.ref().child('images/$imageName').putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrlList.add(downloadUrl);
    }

    // upload image url to firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('content').doc('post').set({
      'images': FieldValue.arrayUnion(imageUrlList),
      'time': FieldValue.serverTimestamp(),
    });
    setState(() {
      showLoading = false;
    });
  }

  // pick video from gallery multiple
  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['mp4', 'avi', 'mov', 'wmv', 'flv', '3gp'],
    );
    if (result != null) {
      setState(() {
        videoList = result;
      });
    }
  }

  // upload video to firebase storage and url to firestore
  Future<void> uploadVideo() async {
    setState(() {
      showLoading = true;
    });
    // upload video to firebase storage
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> videoUrlList = [];

    for (var video in videoList!.files) {
      String videoName = video.name;
      UploadTask uploadTask =
          storage.ref().child('videos/$videoName').putFile(File(video.path!));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      videoUrlList.add(downloadUrl);
    }

    // upload video url to firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('content').doc('reels').set({
      'videos': videoUrlList,
      'time': FieldValue.serverTimestamp(),
    });
    setState(() {
      showLoading = false;
    });
  }

  // read image from firebase storage and get url of all images
  Future<void> readImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    List<String> imageUrlList = [];
    ListResult result = await storage.ref().child('images').listAll();
    for (Reference ref in result.items) {
      String downloadUrl = await ref.getDownloadURL();
      imageUrlList.add(downloadUrl);
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('content').doc('post').set({
      'images': imageUrlList,
      'time': FieldValue.serverTimestamp(),
    });
  }

  // add dummy post to posts collection
  Future<void> addDummyPost() async {
    setState(() {
      showLoading = true;
    });

    try {
      List<PostModel> posts = HelperFunctions().generateDummyPosts(context);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch();
      for (PostModel post in posts) {
        batch.set(firestore.collection('posts').doc(), post.toMap());
      }
      // Commit the batch
      await batch.commit();
      setState(() {
        showLoading = false;
      });
    } catch (e) {
      debugPrint("Error adding dummy posts: $e");
      setState(() {
        showLoading = false;
      });
    }
  }

  // add dummy reels to reels collection
  Future<void> addDummyReels() async {
    setState(() {
      showLoading = true;
    });

    try {
      List<ReelModel> reels = HelperFunctions().generateDummyReels(context);
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      WriteBatch batch = firestore.batch();
      for (ReelModel reel in reels) {
        batch.set(firestore.collection('reels').doc(), reel.toMap());
      }
      // Commit the batch
      await batch.commit();
      setState(() {
        showLoading = false;
      });
    } catch (e) {
      debugPrint("Error adding dummy reels: $e");
      setState(() {
        showLoading = false;
      });
    }
  }
}
