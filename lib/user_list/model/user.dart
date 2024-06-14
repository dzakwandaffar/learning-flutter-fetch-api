class User {
  final String title;
  final String body;

  const User({
    required this.title,
    required this.body,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  get id => null;
}
