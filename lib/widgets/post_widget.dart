import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'dart:math' as math;

import 'package:instagram_clone/utils/app_colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';

class PostWidget extends StatefulWidget {
  final PostModel postModel;
  const PostWidget({super.key, required this.postModel});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  ScrollController dotScrollController = ScrollController();
  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      gradient: AppColors.instaGradient,
                      shape: BoxShape.circle),
                  child: Center(
                    child: CircleAvatar(
                      radius: 20,
                      child: ExtendedImage.network(
                        widget.postModel.userImage,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        shape: BoxShape.circle,
                        alignment: Alignment.topCenter,
                        cache: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(widget.postModel.username),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.ellipsis),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: widget.postModel.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentImageIndex = index;
                      scrollToSelectedDot(index);
                    });
                  },
                  itemBuilder: (context, index) {
                    return ExtendedImage.network(
                      widget.postModel.images[index],
                      fit: BoxFit.fitHeight,
                      cache: true,
                    );
                  },
                ),
                // image number indicator at top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '${currentImageIndex + 1}/${widget.postModel.images.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 15),
                      GestureDetector(
                        child: ExtendedImage.asset(
                          'assets/icons/heart_outlined.png',
                          height: 26,
                          width: 26,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        child: ExtendedImage.asset(
                          'assets/icons/comment_outlined.png',
                          height: 24,
                          width: 24,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        child: ExtendedImage.asset(
                          'assets/icons/share_outlined.png',
                          height: 24,
                          width: 24,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.postModel.images.length > 1)
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 60,
                        child: SingleChildScrollView(
                          controller: dotScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.postModel.images.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  width: currentImageIndex == index ? 5 : 4,
                                  height: currentImageIndex == index ? 5 : 4,
                                  decoration: BoxDecoration(
                                    color: currentImageIndex == index
                                        ? Colors.blue
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: ExtendedImage.asset(
                        'assets/icons/save_outlined.png',
                        height: 24,
                        width: 24,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${numberFormat.format(widget.postModel.likes)} likes',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.postModel.username,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: widget.postModel.caption,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'View all ${widget.postModel.comments} comments',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontWeight: FontWeight.w300,
                      fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(
                  '2 hours ago',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void scrollToSelectedDot(int index) {
    dotScrollController.animateTo(
      index * 8,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
