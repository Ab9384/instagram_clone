class UserModel {
  String? userId;
  String? username;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? email;
  List<String>? following;
  List<String>? followers;
  String? profilePhoto;
  String? bio;
  String? website;
  String? phoneNumber;
  bool? isPrivate = false;

  UserModel(
      {this.userId,
      this.username,
      this.fullName,
      this.email,
      this.dateOfBirth,
      this.gender,
      this.following,
      this.followers,
      this.profilePhoto,
      this.bio,
      this.website,
      this.phoneNumber,
      this.isPrivate});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    fullName = json['fullName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    email = json['email'];
    following = json['following'];
    followers = json['followers'];
    profilePhoto = json['profilePhoto'];
    bio = json['bio'];
    website = json['website'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['fullName'] = fullName;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['email'] = email;
    data['following'] = following;
    data['followers'] = followers;
    data['profilePhoto'] = profilePhoto;
    data['bio'] = bio;
    data['website'] = website;
    data['phoneNumber'] = phoneNumber;
    data['isPrivate'] = isPrivate;
    return data;
  }
}
