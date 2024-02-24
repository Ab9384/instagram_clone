import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/reel_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';

class ReelScreen extends StatefulWidget {
  const ReelScreen({super.key});

  @override
  State<ReelScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelScreen> {
  List<ReelModel> reels = [];
  @override
  void initState() {
    reels = Provider.of<AppData>(context, listen: false).reelsList;
    reels.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Swiper(
          itemCount: reels.length,
          axisDirection: AxisDirection.up,
          loop: false,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            // print('reel index: $index');
            return ReelWidget(reel: reels[index]);
          },
        ),
      ),
    );
  }
}

class ReelWidget extends StatelessWidget {
  final ReelModel reel;
  const ReelWidget({
    super.key,
    required this.reel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Center(
              // child: AspectRatio(
              //     aspectRatio: 9 / 16,
              //     child: ExtendedImage.network(
              //       videoUrl,
              //       fit: BoxFit.cover,
              //       cache: true,
              //     )),
              child: VideoPlayerWidget(
            videoUrl: reel.videoUrl,
            gestureEnabled: true,
            aspectRatio: 9 / 16,
            playSound: true,
          )),
        ),
        // ),
        // reel icon top right
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              CupertinoIcons.camera,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
        // reel icon top left
        const Positioned(
          top: 10,
          left: 10,
          child: Text(
            'Reels',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // side bar with likes, comments, share
        Positioned(
          bottom: 40,
          right: 20,
          child: Column(
            children: [
              ExtendedImage.asset(
                'assets/icons/heart_outlined.png',
                height: 25,
                width: 25,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                compactNumberFormat.format(reel.likes),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              ExtendedImage.asset(
                'assets/icons/comment_outlined.png',
                height: 25,
                width: 25,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                compactNumberFormat.format(reel.comments),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              ExtendedImage.asset(
                'assets/icons/share_outlined.png',
                height: 25,
                width: 25,
                color: Colors.white,
              ),
              const SizedBox(height: 5),
              Text(
                compactNumberFormat.format(reel.shares),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
        ),

        // bottom bar with profile photo,user name, caption
        Positioned(
          bottom: 0,
          left: 5,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ExtendedImage.network(
                        reel.userImage,
                        shape: BoxShape.circle,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          reel.username,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // follow outlend button
                      Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 70),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // caption wiht read more
                  Row(children: [
                    Flexible(
                        child: Text(
                            reel.caption.length > 100
                                ? '${reel.caption.substring(0, 100)}...'
                                : reel.caption,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ))),
                    const SizedBox(width: 80),
                  ])
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
