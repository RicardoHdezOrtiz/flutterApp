class ActorModel {
  final String name;
  final String? profilePath;

  ActorModel({
    required this.name,
    this.profilePath,
  });

  factory ActorModel.fromMap(Map<String, dynamic> map) {
    return ActorModel(
      name: map['name'] ?? '',
      profilePath: map['profile_path'],
    );
  }
}