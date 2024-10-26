// Contact data model
class Friend {
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final int events;

  Friend({
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    this.events = 0, // Default is 0 if not provided
  });
}