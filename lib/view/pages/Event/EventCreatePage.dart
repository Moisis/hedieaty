import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/utils/AppColors.dart';
import 'package:hedieaty/view/components/widgets/buttons/IconButton.dart';
import 'package:hedieaty/view/components/widgets/nav/CustomAppBar.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/event/add_event.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../utils/RandomIdGenerator.dart';

class EventCreationPage extends StatefulWidget {
  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  String UserAuthId = '';
  // late GetUsers getUsersUseCase;
  // late SyncUsers syncUsersUseCase;

  late SyncEvents syncEventsUseCase;
  // late GetEvents getEventsUseCase;
  late AddEvent addEventUseCase;
  late GetUserAuthId  getUserAuthIdUseCase;

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = EventEntity(
        EventId: randomAlphaNumeric(DateTime.now().millisecondsSinceEpoch % 100),
        EventName: _eventNameController.text,
        EventDate: _eventDateController.text,
        EventLocation:  _eventLocationController.text,
        EventImageUrl: _selectedImageUrl! ,
        EventDescription: _eventDescriptionController.text,
        UserId: UserAuthId,
      );


      addEventUseCase.call(newEvent);

      // Simulate sending data to the database
      debugPrint("Event Created: $newEvent");

      // Clear the form after submission
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      Navigator.pop(context ,true);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchImagesFromApi();
    _intialize();
  }

  List<String> _imageUrls = []; // List to store image URLs fetched from API
  String? _selectedImageUrl; // Store the selected image URL


  Future<void> _fetchImagesFromApi() async {
    setState(() {
      _imageUrls = [
      'https://picsum.photos/300/300?id=1&category=events',
      'https://picsum.photos/300/300?id=2&category=events',
      'https://picsum.photos/300/300?id=3&category=events',
      'https://picsum.photos/300/300?id=4&category=events',
      'https://picsum.photos/300/300?id=5&category=events',
      'https://picsum.photos/300/300?id=6&category=events',];
    });
  }

  void _selectImage(String imageUrl) {
    setState(() {
      _selectedImageUrl = imageUrl;
    });
  }

  void _intialize() async {

    final userRepository = UserRepositoryImpl(
      sqliteDataSource:  SQLiteUserDataSource(),
      firebaseDataSource: FirebaseUserDataSource(),
      firebaseAuthDataSource: FirebaseAuthDataSource(),
    );

    final eventRepository = EventRepositoryImpl(
      sqliteDataSource: SQLiteEventDataSource(),
      firebaseDataSource: FirebaseEventDataSource(),
    );
    syncEventsUseCase = SyncEvents(eventRepository);

    addEventUseCase = AddEvent(eventRepository);

    getUserAuthIdUseCase = GetUserAuthId(userRepository);

    UserAuthId = await getUserAuthIdUseCase.call();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create Event',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _eventNameController,
                          decoration: InputDecoration(labelText: 'Event Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Event Name is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _eventDateController,
                          decoration: InputDecoration(labelText: 'Event Date'),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _eventDateController.text =
                              selectedDate.toIso8601String().split('T')[0];
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Event Date is required';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _eventLocationController,
                          decoration:
                          InputDecoration(labelText: 'Event Location'),
                        ),
                        TextFormField(
                          controller: _eventDescriptionController,
                          decoration:
                          InputDecoration(labelText: 'Event Description'),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        Text('Select an Event Image', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        if (_imageUrls.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: _imageUrls.length,
                            itemBuilder: (context, index) {
                              final imageUrl = _imageUrls[index];
                              return GestureDetector(
                                onTap: () => _selectImage(imageUrl),
                                child: Stack(
                                  children: [
                                    Image.network(imageUrl, fit: BoxFit.cover),
                                    if (_selectedImageUrl == imageUrl)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Icon(Icons.check_circle,
                                            color: Colors.green),
                                      ),
                                  ],
                                ),
                              );
                            },
                          )
                        else
                          CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    IC_button(
                      title: 'Add Event ',
                      icon: Icon(Icons.edit_calendar, color: AppColors.white),
                      onPress: _createEvent,
                      color: AppColors.secondary,
                      fontsize: 14,
                      width: 150,
                      height: 70,
                    ),
                    SizedBox(width: 50),
                    IC_button(
                      title: 'Cancel ',
                      icon: Icon(Icons.cancel, color: AppColors.white),
                      onPress: () {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      fontsize: 14,
                      width: 150,
                      height: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
