class StoryModel {
  String userId;
  String username;
  String userImage;
  List<StoryFileModel> storyItems;

  StoryModel({
    required this.userId,
    required this.username,
    required this.userImage,
    required this.storyItems,
  });

  StoryModel.fromMap(Map<String, dynamic> data)
      : userId = data['userId'],
        username = data['username'],
        userImage = data['userImage'],
        storyItems = List<StoryFileModel>.from(
          data['stories'].map(
            (story) => StoryFileModel.fromMap(story),
          ),
        );
}

class StoryFileModel {
  String id;
  String type;
  String url;
  bool isViewed = false;

  StoryFileModel({
    required this.id,
    required this.type,
    required this.url,
  });

  StoryFileModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        type = data['type'],
        url = data['url'];
}
