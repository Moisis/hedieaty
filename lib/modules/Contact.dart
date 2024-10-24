// Contact data model
class Contact {
  final String name;
  final String phoneNumber;
  final String profileImageUrl;
  final int events;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
    this.events = 0, // Default is 0 if not provided
  });
}