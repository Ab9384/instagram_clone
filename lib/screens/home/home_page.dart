// ignore_for_file: use_build_context_synchronously

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/functions/helper_functions.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/widgets/post_widget.dart';
import 'package:instagram_clone/widgets/stories_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    if (Provider.of<AppData>(context, listen: false).postList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<AppData>(context, listen: false).setPostList =
            HelperFunctions().generateDummyPosts(context);
        Provider.of<AppData>(context, listen: false).setStoriesList =
            HelperFunctions().generateDummyStories(context);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<PostModel> postList = Provider.of<AppData>(context).postList;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              title: ExtendedImage.asset(
                'assets/logo/text_logo.png',
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                alignment: Alignment.center,
                width: 100,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: ExtendedImage.asset(
                    'assets/icons/heart_outlined.png',
                    height: 24,
                    width: 24,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: ExtendedImage.asset(
                    'assets/icons/message_outlined.png',
                    height: 24,
                    width: 24,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
              floating: true,
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                List<PostModel> postList =
                    HelperFunctions().generateDummyPosts(context);
                Provider.of<AppData>(context, listen: false).setPostList =
                    postList;

                List<StoryModel> storiesList =
                    HelperFunctions().generateDummyStories(context);
                Provider.of<AppData>(context, listen: false).setStoriesList =
                    storiesList;
                await Future<void>.delayed(
                  const Duration(milliseconds: 2000),
                );
              },
            ),
            // Stories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: Provider.of<AppData>(context).storiesList.length,
                  itemBuilder: (context, index) {
                    StoryModel storyModel =
                        Provider.of<AppData>(context).storiesList[index];
                    return Row(
                      children: [
                        if (index == 0) const MyStoryWidget(),
                        StoriesWidget(story: storyModel),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 5),
            ),
            // divider
            const SliverToBoxAdapter(
              child: Divider(
                // height: 0.1,
                thickness: 0.2,
                color: Colors.grey,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 5),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostWidget(postModel: postList[index]);
                },
                childCount: postList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
