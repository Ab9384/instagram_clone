import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<PostModel> postImageList = [];
  List<String> reelVideoList = [];
  int totalELements = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        postImageList = Provider.of<AppData>(context, listen: false).postList;
        reelVideoList =
            Provider.of<AppData>(context, listen: false).reelVideoList;
        totalELements = calculateTotalElements();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        //  sliver app bar with search bar
        SliverAppBar(
          floating: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 10),
                Text(
                  'Search',
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                )
              ],
            ),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            setState(() {
              postImageList.shuffle();
              reelVideoList.shuffle();
            });
            await Future<void>.delayed(
              const Duration(milliseconds: 1500),
            );
          },
        ),

        SliverGrid.builder(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            crossAxisSpacing: 2,
            pattern: [
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(2, 1),
              const QuiltedGridTile(1, 1),
              const QuiltedGridTile(1, 1),
            ],
          ),
          itemBuilder: (context, index) {
            return Container(
                color: Colors.grey,
                child: Center(
                  child: !isReelIndex(index)
                      // ? Text('Image ${index - (index ~/ 5)}')
                      // : index ~/ 5 < reelVideoList.length
                      //     ? Text('Reel ${index ~/ 5}')
                      //     : Text('Image ${index - (index ~/ 5)}')
                      ? SearchPageImageWidget(
                          aspectRatio: 1,
                          postImageUrl:
                              postImageList[index - (index ~/ 5)].images)
                      : index ~/ 5 < reelVideoList.length
                          ? VideoPlayerWidget(
                              videoUrl: reelVideoList[index ~/ 5],
                              gestureEnabled: false,
                            )
                          : SearchPageImageWidget(
                              aspectRatio: 1 / 2,
                              postImageUrl:
                                  postImageList[index - (index ~/ 5)].images),
                ));
          },
          itemCount: totalELements,
        )
      ]),
    ));
  }

  bool isReelIndex(int index) {
    if (index == 2) {
      return true;
    } else {
      int offset = (index) % 10;
      return offset == 2 || offset == 5;
    }
  }

  int calculateTotalElements() {
    int noOfReels = reelVideoList.length;
    int noOfImages = postImageList.length;
    int totalElements = 0;

    // Calculate the maximum number of reels that can be used based on the image count
    int maxReels =
        noOfImages ~/ 4; // Divide images by 4 to get the maximum possible reels

    // Ensure the number of reels doesn't exceed the available reels
    int actualReels = math.min(maxReels, noOfReels);

    // Calculate the number of images to be used based on the actual reels
    int imagesToUse = actualReels * 4;

    // Calculate the total elements by adding the actual reels and images to be used
    totalElements = imagesToUse + actualReels;

    return totalElements;
  }
}

class SearchPageImageWidget extends StatelessWidget {
  const SearchPageImageWidget({
    super.key,
    required this.postImageUrl,
    required this.aspectRatio,
  });

  final List<String> postImageUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: aspectRatio,
          child: ExtendedImage.network(
            postImageUrl[0],
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (state.extendedImageLoadState == LoadState.failed) {
                return const Center(
                  child: Text(''),
                );
              } else {
                return null;
              }
            },
          ),
        ),
        // reel icon top right
        Positioned(
          top: 10,
          right: 10,
          child: ExtendedImage.asset(
            'assets/icons/multiple_image.png',
            height: 15,
            width: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
