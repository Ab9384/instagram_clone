class PostModel {
  String id;
  String userId;
  String username;
  String userImage;
  List<String> images;
  String caption;
  String location;
  int likes;
  int comments;
  int shares;
  String time;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImage,
    required this.images,
    required this.caption,
    required this.location,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.time,
  });

  PostModel.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        userId = data['userId'],
        username = data['username'],
        userImage = data['userImage'],
        images = List<String>.from(data['images']),
        caption = data['caption'],
        location = data['location'],
        likes = data['likes'],
        comments = data['comments'],
        shares = data['shares'],
        time = data['time'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImage': userImage,
      'images': images,
      'caption': caption,
      'location': location,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'time': time,
    };
  }
}
