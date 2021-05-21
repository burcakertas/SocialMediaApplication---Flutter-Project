class Feed {
  final String id;
  final String name;
  final String username;
  final String picture;
  final String content;
  final String media;

  Feed({this.id,  this.name,  this.username,  this.picture, this.content,this.media});

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      picture: json['p_pic'],
      content:json['content'],
      media:json['media']
    );
  }
}