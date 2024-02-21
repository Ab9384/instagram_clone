import 'dart:math';

import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // save device theme preference to shared preferences
  static Future<void> saveThemePreference(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
  }

  //generate dummy posts
  List<PostModel> generateDummyPosts(context) {
    List<PostModel> posts = [];
    List<String> postImages =
        Provider.of<AppData>(context, listen: false).postImageList;
    Random random = Random();

    for (int i = 0; i < postImages.length; i++) {
      int likes = random.nextInt(1000000);
      int comments = random.nextInt(5000);
      int randomIndex = random.nextInt(49);
      PostModel post = PostModel(
        id: 'post_$i',
        userId: 'user_$i',
        username: northIndianNames[randomIndex],
        userImage:
            isMale(northIndianNames[randomIndex]) ? maleAvatar : femaleAvatar,
        images: [
          postImages[random.nextInt(postImages.length)],
          postImages[random.nextInt(postImages.length)],
          postImages[random.nextInt(postImages.length)],
          postImages[random.nextInt(postImages.length)],
          postImages[random.nextInt(postImages.length)],
          postImages[random.nextInt(postImages.length)],
        ],
        caption: 'Caption for post $i',
        location: 'Location $i',
        likes: likes,
        comments: comments,
        shares: i * 2,
        time: 'Time for post $i',
      );
      posts.add(post);
    }

    return posts;
  }

  //generate dummy stories
  List<StoryModel> generateDummyStories(context) {
    List<StoryModel> stories = [];
    List<String> postImages =
        Provider.of<AppData>(context, listen: false).postImageList;
    List<String> reelVideos =
        Provider.of<AppData>(context, listen: false).reelVideoList;
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      List<StoryFileModel> storyFiles = [];
      for (int j = 0; j < 5; j++) {
        if (j.isEven) {
          StoryFileModel storyFile = StoryFileModel(
            id: 'post_$j',
            type: 'image',
            url: postImages[random.nextInt(postImages.length)],
          );
          storyFiles.add(storyFile);
        } else {
          StoryFileModel storyFile = StoryFileModel(
            id: 'reel_$j',
            type: 'video',
            url: reelVideos[random.nextInt(reelVideos.length)],
          );
          storyFiles.add(storyFile);
        }
      }
      int randomIndex = random.nextInt(49);
      StoryModel story = StoryModel(
        userId: 'user_$i',
        username: northIndianNames[randomIndex],
        userImage:
            isMale(northIndianNames[randomIndex]) ? maleAvatar : femaleAvatar,
        stories: storyFiles,
      );
      stories.add(story);
    }
    return stories;
  }
}
