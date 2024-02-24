class ReelModel {
  String id;
  String userId;
  String username;
  String userImage;
  String videoUrl;
  String caption;
  String location;
  int likes;
  int comments;
  List<dynamic> commentsData;
  int shares;
  String time;

  ReelModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.videoUrl,
    required this.caption,
    required this.location,
    required this.likes,
    required this.comments,
    required this.commentsData,
    required this.shares,
    required this.time,
  });

  ReelModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        username = data['username'],
        userImage = data['userImage'],
        videoUrl = data['video'],
        caption = data['caption'],
        location = data['location'],
        likes = data['likes'],
        comments = data['comments'],
        commentsData = data['commentsData'] ?? [],
        shares = data['shares'],
        time = data['time'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'video': videoUrl,
      'caption': caption,
      'location': location,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'time': time,
    };
  }
}
