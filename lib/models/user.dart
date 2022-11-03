final String userTable = 'user';

class UserFields {
  static final String username = 'username';
  static final String name = 'name';
  static final List<String> allFields = [username, name];
}

class User {
  final String username; // User not allowed to change username later "final"
  String name; // User can change name later "non-final "

  User({
    required this.username,
    required this.name,
  });

// Sending data into the database as a map
  Map<String, Object?> toJson() => {
        UserFields.username: username,
        UserFields.name: name,
      };

// Getting data from the database
  static User fromJson(Map<String, Object?> json) => User(
        username: json[UserFields.username] as String,
        name: json[UserFields.name] as String,
      );
}
