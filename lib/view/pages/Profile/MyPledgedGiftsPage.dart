import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/gift_entity.dart';
import 'package:hedieaty/domain/usecases/event/getSingleEvent.dart';
import 'package:hedieaty/domain/usecases/gifts/getPledgedGifts.dart';
import 'package:hedieaty/domain/usecases/user/getUserAuthId.dart';

import '../../../data/database/local/sqlite_event_dao.dart';
import '../../../data/database/local/sqlite_gift_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_event_dao.dart';
import '../../../data/database/remote/firebase_gift_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/event_repository_impl.dart';
import '../../../data/repos/gift_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

class PledgedGiftsPage extends StatefulWidget {
  const PledgedGiftsPage({super.key});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {
  @override
  void initState() {
    super.initState();
    _intitialize();
    _getPledgedGifts();
  }

  late GetPledgedGifts getPledgedGiftsUseCase;
  late GetUserAuthId getUserAuthIdUseCase;

  List<GiftEntity> _pledgedGifts = [];

  late GetSingleEvent getSingleEventUseCase;

  void _intitialize() async {
    try {
      final giftRepository = GiftRepositoryImpl(
        sqliteDataSource: SQLiteGiftDataSource(),
        firebaseDataSource: FirebaseGiftDataSource(),
      );

      final userRepository = UserRepositoryImpl(
        sqliteDataSource: SQLiteUserDataSource(),
        firebaseDataSource: FirebaseUserDataSource(),
        firebaseAuthDataSource: FirebaseAuthDataSource(),
      );

      final eventRepository = EventRepositoryImpl(
        sqliteDataSource: SQLiteEventDataSource(),
        firebaseDataSource: FirebaseEventDataSource(),
      );

      getSingleEventUseCase = GetSingleEvent(eventRepository);
      getUserAuthIdUseCase = GetUserAuthId(userRepository);
      getPledgedGiftsUseCase = GetPledgedGifts(giftRepository);
    } catch (e) {
      print('Error During Initialization $e');
    }
  }

  void _getPledgedGifts() async {
    final pledgedGifts =
        await getPledgedGiftsUseCase.call(await getUserAuthIdUseCase.call());
    setState(() {
      _pledgedGifts = pledgedGifts!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pledged Gifts ',
        showBackButton: true,
      ),
      body: _pledgedGifts.isEmpty
          ? Center(
              child: Text(
                'No Pledged Gifts',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            )
          : ListView.builder(
              itemCount: _pledgedGifts.length,
              itemBuilder: (context, index) {
                final gift = _pledgedGifts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.card_giftcard,
                                    color: Colors.white),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gift.GiftName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '${gift.GiftPrice} EGP',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Event Details:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          FutureBuilder<String>(
                            future: getSingleEventUseCase(gift.GiftEventId)
                                .then((event) =>
                                    event?.EventName ?? 'Unknown Event'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading...');
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Text(
                                  snapshot.data ?? 'Unknown Event',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14.0,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
