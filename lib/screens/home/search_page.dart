import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> postImageList = [];
  List<String> reelVideoList = [];
  @override
  void initState() {
    setState(() {
      postImageList =
          Provider.of<AppData>(context, listen: false).postImageList;
      reelVideoList =
          Provider.of<AppData>(context, listen: false).reelVideoList;
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
                          postImageUrl: postImageList[index - (index ~/ 5)])
                      : index ~/ 5 < reelVideoList.length
                          ? VideoPlayerWidget(
                              videoUrl: reelVideoList[index ~/ 5],
                            )
                          : SearchPageImageWidget(
                              aspectRatio: 1 / 2,
                              postImageUrl:
                                  postImageList[index - (index ~/ 5)]),
                ));
          },
          itemCount: postImageList.length + reelVideoList.length,
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
}

class SearchPageImageWidget extends StatelessWidget {
  const SearchPageImageWidget({
    super.key,
    required this.postImageUrl,
    required this.aspectRatio,
  });

  final String postImageUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ExtendedImage.network(
        postImageUrl,
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
    );
  }
}
