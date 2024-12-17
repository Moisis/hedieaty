import 'package:flutter/material.dart';
import 'package:hedieaty/data/database/local/sqlite_gift_dao.dart';
import 'package:hedieaty/data/database/remote/firebase_gift_dao.dart';
import 'package:hedieaty/data/repos/gift_repository_impl.dart';
import 'package:hedieaty/domain/entities/event_entity.dart';
import 'package:hedieaty/domain/entities/gift_entity.dart';

import 'package:hedieaty/domain/usecases/gifts/add_gift.dart';
import 'package:hedieaty/domain/usecases/gifts/get_gifts_event.dart';
import 'package:hedieaty/domain/usecases/gifts/sync_gifts.dart';
import 'package:hedieaty/utils/AppColors.dart';

import '../../components/widgets/nav/CustomAppBar.dart';


class EventDetails extends StatefulWidget {
  final EventEntity event; // Pass the event object to this screen

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late ScrollController _controller = ScrollController();

  List<GiftEntity> gifts = [];

  @override
  void initState() {
    super.initState();
    _initializeGifts();

  }

  late GetGiftsEvent getGiftsEvent;
  late AddGift addGift;
  late SyncGifts syncGifts;



  Future<void> _initializeGifts() async {
    try {

      final sqliteDataSource = SQLiteGiftDataSource();
      final firebaseDataSource = FirebaseGiftDataSource();

      final  giftRepository = GiftRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
      );

      getGiftsEvent = GetGiftsEvent(giftRepository);
      addGift = AddGift(giftRepository);
      syncGifts = SyncGifts(giftRepository);


      // addGift.call(GiftEntity(
      //   GiftId: '1',
      //   GiftName: 'Gift 1',
      //   GiftDescription: 'Gift 1 Description',
      //   GiftPrice: 100,
      //   GiftCat: 'Gift 1 Category',
      //   GiftStatus: 'Gift 1 Status',
      //   GiftEventId: widget.event.EventId,
      // ));

      await syncGifts.call();

      gifts = await getGiftsEvent.call(widget.event.EventId);

      setState(() {

      });

    } catch (e) {
      debugPrint('Error during initialization: $e');
    }finally{

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Event Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              Text(
                '${widget.event.EventName}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.event.EventDescription}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.pin_drop),
                    label: Text("${widget.event.EventLocation}"),

                    style: ButtonStyle(
                      iconColor : WidgetStateProperty.all(AppColors.primary),
                      foregroundColor: WidgetStateProperty.all(AppColors.primary),
                    ),
                  ),

                  SizedBox(width: 16),
                  // Event Date
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month),
                    label: Text("${widget.event.EventDate}"),
                    style: ButtonStyle(
                      iconColor : WidgetStateProperty.all(AppColors.primary),
                      foregroundColor: WidgetStateProperty.all(AppColors.primary),

                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Gifts List Header
              const Text(
                'Gifts List',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Gifts List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // itemCount: widget.event.gifts.length,
                itemCount: gifts.length,

                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.card_giftcard,
                        color: Colors.pink,
                      ),
                      title: Text(
                        gift.GiftName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        gift.GiftDescription,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        gift.GiftPrice.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _addFriendWindow();
        },
        child: const Icon(
          Icons.add_task,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
