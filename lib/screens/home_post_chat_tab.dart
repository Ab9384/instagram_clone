import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/home/landing_screen.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/widgets/primary_button.dart';

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
      body: TabBarView(controller: tabController, children: [
        Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: PrimaryButton(
            buttonText: 'Add reels',
            showLoading: showLoading,
            onPressed: () async {},
          ),
        )),
        const LandingScreen(),
        const Center(child: Text('Chats')),
      ]),
    );
  }

  // // pick image from gallery multiple
  // Future<void> pickImage() async {
  //   final ImagePicker picker = ImagePicker();
  //   final List<XFile> images = await picker.pickMultiImage();
  //   setState(() {
  //     imageList = images;
  //   });
  // }

  // // upload image to firebase storage and url to firestore
  // Future<void> uploadImage() async {
  //   setState(() {
  //     showLoading = true;
  //   });
  //   // upload image to firebase storage
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   List<String> imageUrlList = [];

  //   for (var image in imageList) {
  //     String imageName = image.path.split('/').last; // Extracting image name
  //     UploadTask uploadTask =
  //         storage.ref().child('images/$imageName').putFile(File(image.path));
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     imageUrlList.add(downloadUrl);
  //   }

  //   // upload image url to firestore
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   await firestore.collection('content').doc('post').set({
  //     'images': imageUrlList,
  //     'time': FieldValue.serverTimestamp(),
  //   });
  //   setState(() {
  //     showLoading = false;
  //   });
  // }

  // // pick video from gallery multiple
  // Future<void> pickVideo() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowMultiple: true,
  //     allowedExtensions: ['mp4', 'avi', 'mov', 'wmv', 'flv', '3gp'],
  //   );
  //   if (result != null) {
  //     setState(() {
  //       videoList = result;
  //     });
  //   }
  // }

  // // upload video to firebase storage and url to firestore
  // Future<void> uploadVideo() async {
  //   setState(() {
  //     showLoading = true;
  //   });
  //   // upload video to firebase storage
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   List<String> videoUrlList = [];

  //   for (var video in videoList!.files) {
  //     String videoName = video.name;
  //     UploadTask uploadTask =
  //         storage.ref().child('videos/$videoName').putFile(File(video.path!));
  //     TaskSnapshot snapshot = await uploadTask;
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     videoUrlList.add(downloadUrl);
  //   }

  //   // upload video url to firestore
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   await firestore.collection('content').doc('reels').set({
  //     'videos': videoUrlList,
  //     'time': FieldValue.serverTimestamp(),
  //   });
  //   setState(() {
  //     showLoading = false;
  //   });
  // }

  // // read image from firebase storage and get url of all images
  // Future<void> readImage() async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   List<String> imageUrlList = [];
  //   ListResult result = await storage.ref().child('images').listAll();
  //   for (Reference ref in result.items) {
  //     String downloadUrl = await ref.getDownloadURL();
  //     imageUrlList.add(downloadUrl);
  //   }
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   await firestore.collection('content').doc('post').set({
  //     'images': imageUrlList,
  //     'time': FieldValue.serverTimestamp(),
  //   });
  // }
}
