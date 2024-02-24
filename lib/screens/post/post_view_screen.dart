import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/widgets/post_widget.dart';
import 'package:provider/provider.dart';

class PostViewScreen extends StatefulWidget {
  final PostModel postModel;
  const PostViewScreen({super.key, required this.postModel});

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  List<PostModel> postImageList = [];

  @override
  void initState() {
    setState(() {
      postImageList = getPostList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                floating: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                centerTitle: false,
                title: const Text(
                  'Explore',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SliverToBoxAdapter(
                  child: PostWidget(
                postModel: widget.postModel,
              )),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverList.builder(
                  itemCount: postImageList.length,
                  itemBuilder: (context, index) {
                    return PostWidget(
                      postModel: postImageList[index],
                    );
                  })
            ],
          ),
        ));
  }

  List<PostModel> getPostList() {
    List<PostModel> postImageList = [];
    postImageList = Provider.of<AppData>(context, listen: false).postList;
    postImageList.remove(widget.postModel);
    postImageList.shuffle();
    return postImageList;
  }
}
