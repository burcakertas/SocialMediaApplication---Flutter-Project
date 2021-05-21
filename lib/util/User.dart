class User_ {
  final String id;
  final String name;
  final String username;
  final String picture;
  final int followings;
  final int followers;
  User_({this.id,this.name,  this.username,  this.followings,  this.followers, this.picture});

  factory User_.fromJson(Map<String, dynamic> json) {
    return User_(
      name: json['name'],
      username: json['username'],
      picture: json['picUrl'],

    );
  }
}