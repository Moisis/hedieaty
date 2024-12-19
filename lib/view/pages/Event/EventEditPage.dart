import 'package:flutter/material.dart';


import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/usecases/event/sync_events.dart';
import '../../../domain/usecases/event/update_event.dart';
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../utils/AppColors.dart';
import '../../components/widgets/buttons/IconButton.dart';

class EditEventPage extends StatefulWidget {
  final EventEntity event;

  const EditEventPage({super.key, required this.event});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventLocationController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();


  late SyncEvents syncEventsUseCase;

  late UpdateEvent updateEventUseCase;
  late GetUserAuthId  getUserAuthIdUseCase;

  @override
  void initState() {
    super.initState();

    _initializeForm();


  }

  void  _initializeForm(){
    _eventNameController.text = widget.event.EventName;
    _eventDateController.text = widget.event.EventDate;
    _eventLocationController.text = widget.event.EventLocation;
    _eventDescriptionController.text = widget.event.EventDescription;



    final userRepository = UserRepositoryImpl(

      firebaseAuthDataSource: FirebaseAuthDataSource(),
    );

    getUserAuthIdUseCase = GetUserAuthId(userRepository);


    final eventRepository = EventRepositoryImpl(
      sqliteDataSource: SQLiteEventDataSource(),
      firebaseDataSource: FirebaseEventDataSource(),
    );

    updateEventUseCase = UpdateEvent(eventRepository);
    syncEventsUseCase = SyncEvents(eventRepository);


    setState(() {

    });

  }

  Future<void> _editEvent() async {
    if (_formKey.currentState!.validate()) {
      final updatedEvent = EventEntity(
        EventId: widget.event.EventId,
        EventName: _eventNameController.text,
        EventDate: _eventDateController.text,
        EventLocation: _eventLocationController.text,
        EventImageUrl: widget.event.EventImageUrl,
        EventDescription: _eventDescriptionController.text,
        UserId: widget.event.UserId,
      );

      await updateEventUseCase.call(updatedEvent);

      // Simulate sending data to the database
      debugPrint("Event Updated: $updatedEvent");

      // Clear the form after submission
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully!')),
      );

      syncEventsUseCase.call();
      Navigator.pop(context ,true );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Event')),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter event name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventDateController,
                decoration: InputDecoration(labelText: 'Event Date'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter event date' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventLocationController,
                decoration: InputDecoration(labelText: 'Event Location'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter event location' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(labelText: 'Event Description'),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter event Description' : null,
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  IC_button(
                    title: 'Add Event ',
                    icon: Icon(Icons.edit_calendar, color: AppColors.white),
                    onPress: _editEvent,
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
    );
  }

}