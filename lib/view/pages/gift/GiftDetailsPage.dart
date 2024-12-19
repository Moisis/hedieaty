import 'dart:async';
import 'package:hedieaty/utils/notification/notification_helper.dart';

import 'package:flutter/material.dart';
import 'package:hedieaty/domain/entities/gift_entity.dart';
import 'package:hedieaty/view/components/widgets/buttons/IconButton.dart';

import '../../../data/database/local/sqlite_gift_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_gift_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/gift_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/usecases/gifts/getStreamGift.dart';
import '../../../domain/usecases/gifts/update_gift.dart';
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../domain/usecases/user/getUserbyId.dart';
import '../../../utils/AppColors.dart';
import '../../../utils/notification/FCM_Firebase.dart';
import '../../components/widgets/nav/CustomAppBar.dart';

class GiftDetailsPage extends StatefulWidget {
  final EventEntity event;
  late GiftEntity gift;

  GiftDetailsPage({super.key, required this.event, required this.gift});

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final ScrollController _controller = ScrollController();

  late GetStreamGift getGiftsStream;
  late Stream<List<GiftEntity>> giftsStream;
  late StreamSubscription<List<GiftEntity>> _giftsSubscription2;
  List<GiftEntity> gifts = [];
  bool _isPledged = false;


  NotificationService _notificationService = NotificationService();
  final FirestoreService _firestoreService = FirestoreService();


  late GetUserById getUserById;
  late GetUserAuthId getUserAuthId;
  late UpdateGift updateGiftUseCase;

  @override
  void initState() {
    super.initState();
    _intializedGift();
    _subscribeToGifts();
  }

  void _intializedGift() {
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

      getUserById = GetUserById(userRepository);
      getUserAuthId = GetUserAuthId(userRepository);

      getGiftsStream = GetStreamGift(giftRepository);

      updateGiftUseCase = UpdateGift(giftRepository);
    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  void _updatePledgedStatus() {
    setState(() {
      _isPledged = widget.gift.GiftStatus != 'Available';
    });
  }

  Future<void> _subscribeToGifts() async {

    _isPledged = widget.gift.GiftStatus != 'Available' ? true : false;

    giftsStream = getGiftsStream.call(widget.event.EventId);

    _giftsSubscription2 = giftsStream.listen((updatedGifts) {

      gifts = updatedGifts.where((gift) => gift.GiftId == widget.gift.GiftId).toList();
      if (gifts.isNotEmpty) {
        widget.gift = gifts[0];
        _updatePledgedStatus();
      }
      if (mounted) {
        setState(() {});
      }
    });


  }

  @override
  void dispose() {
    _giftsSubscription2.cancel();
    super.dispose();
  }


  Future<void> _pledgeGift() async {
    final userAuthId = await getUserAuthId.call();

    if (widget.gift.GiftStatus != userAuthId && widget.event.UserId == userAuthId) {
      _showError();
      return;
    }else{
    final updatedGift = GiftEntity(
      GiftId: widget.gift.GiftId,
      GiftName: widget.gift.GiftName,
      GiftDescription: widget.gift.GiftDescription,
      GiftPrice: widget.gift.GiftPrice,
      GiftStatus: userAuthId,
      GiftCat: widget.gift.GiftCat,
      GiftEventId:widget.gift.GiftEventId,
    );

    await updateGiftUseCase.call(updatedGift);

    var userMap = await _firestoreService.getFcm2(widget.event.UserId);


    _notificationService.sendNotification(userMap!, 'Gift Pledged', 'A ${widget.gift.GiftName} gift has been pledged for ${widget.event.EventName} Event  by ${await getUserById.call(userAuthId).then((user) => user.UserName)}');

    }
  }

  Future _showError() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('You cannot pledge this gift.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _unpledgeGift() async {
    final userAuthId = await getUserAuthId.call();


    if (widget.event.UserId != userAuthId){
      if (widget.gift.GiftStatus != userAuthId){
        _showError();
        return;
      }
    }else{
      _showError();
      return;
    }

    final updatedGift = GiftEntity(
      GiftId: widget.gift.GiftId,
      GiftName: widget.gift.GiftName,
      GiftDescription: widget.gift.GiftDescription,
      GiftPrice: widget.gift.GiftPrice,
      GiftStatus: 'Available',
      GiftCat: widget.gift.GiftCat,
      GiftEventId: widget.gift.GiftEventId,
    );

    await updateGiftUseCase.call(updatedGift);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gift Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Ink.image(
                image: NetworkImage(widget.event.EventImageUrl),
                height: 200,
                fit: BoxFit.cover,
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GIFT DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.gift.GiftName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(widget.gift.GiftDescription),
                                SizedBox(height: 10),
                                Text(
                                  'Price: ${widget.gift.GiftPrice.toStringAsFixed(2)} EGP',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Event Date: ${widget.event.EventDate}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<String>(
                        future: getUserById.call(widget.gift.GiftStatus).then((user) => user.UserName),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(color: Colors.grey),
                            );
                          } else if (snapshot.hasData) {
                            // Return the user name when data is available
                            return Text(

                              'Pledged by ${snapshot.data}',
                              style: const TextStyle(color: Colors.grey),
                            );
                          } else {
                            // Return an error message if the future fails
                            return SizedBox.shrink();
                          }
                        },
                      ),

                      _isPledged ? IC_button(
                        title: 'UnPledge',
                        icon: Icon(Icons.remove_circle_outline, color: AppColors.white),
                        onPress: _unpledgeGift,
                        color: Colors.grey,
                        fontsize: 14,
                        width: double.infinity,
                        height: 50,
                      ) : IC_button(
                        title: 'Pledge',
                        icon: Icon(Icons.add_box_rounded, color: AppColors.white),
                        onPress: _pledgeGift,
                        color: AppColors.secondary,
                        fontsize: 14,
                        width: double.infinity,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

    );
  }
}
