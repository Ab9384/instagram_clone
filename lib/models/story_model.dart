class StoryModel {
  String userId;
  String username;
  String userImage;
  List<StoryFileModel> stories;

  StoryModel({
    required this.userId,
    required this.username,
    required this.userImage,
    required this.stories,
  });

  StoryModel.fromMap(Map<String, dynamic> data)
      : userId = data['userId'],
        username = data['username'],
        userImage = data['userImage'],
        stories = List<StoryFileModel>.from(
          data['stories'].map(
            (story) => StoryFileModel.fromMap(story),
          ),
        );
}

class StoryFileModel {
  String id;
  String type;
  String url;

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
