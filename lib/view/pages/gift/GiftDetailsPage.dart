import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hedieaty/view/components/widgets/buttons/IconButton.dart';
import '../../../data/database/local/sqlite_gift_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_gift_dao.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/repos/gift_repository_impl.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/gift_entity.dart';
import '../../../domain/usecases/gifts/getStreamGift.dart';
import '../../../domain/usecases/gifts/update_gift.dart';
import '../../../domain/usecases/gifts/delete_gift.dart'; // Add delete use case
import '../../../domain/usecases/user/getUserAuthId.dart';
import '../../../domain/usecases/user/getUserbyId.dart';
import '../../../utils/AppColors.dart';
import '../../../utils/notification/FCM_Firebase.dart';
import '../../../utils/notification/notification_helper.dart';
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
  late DeleteGift deleteGiftUseCase; // Add the delete use case

  final giftNameController = TextEditingController();
  final giftDescriptionController = TextEditingController();
  final giftPriceController = TextEditingController();
  final giftcatController = TextEditingController();

  String? selectedCategory;
  List<String> categories = [
    'Toys',
    'Books',
    'Electronics',
    'Accessories',
    'Clothing',
    'Food & Drinks',
    'Other'
  ];
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
      deleteGiftUseCase =
          DeleteGift(giftRepository); // Initialize delete use case
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
      gifts = updatedGifts
          .where((gift) => gift.GiftId == widget.gift.GiftId)
          .toList();
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
    giftNameController.dispose();
    giftDescriptionController.dispose();
    giftPriceController.dispose();
    giftcatController.dispose();
    super.dispose();
  }

  Future<void> _pledgeGift() async {
    final userAuthId = await getUserAuthId.call();

    if (widget.gift.GiftStatus != userAuthId &&
        widget.event.UserId == userAuthId) {
      _showError();
      return;
    } else {
      final updatedGift = GiftEntity(
        GiftId: widget.gift.GiftId,
        GiftName: widget.gift.GiftName,
        GiftDescription: widget.gift.GiftDescription,
        GiftPrice: widget.gift.GiftPrice,
        GiftStatus: userAuthId,
        GiftCat: widget.gift.GiftCat,
        GiftEventId: widget.gift.GiftEventId,
      );

      await updateGiftUseCase.call(updatedGift);

      var userMap = await _firestoreService.getFcm2(widget.event.UserId);
      _notificationService.sendNotification(
        userMap!,
        'Gift Pledged',
        'A ${widget.gift.GiftName} gift has been pledged for ${widget.event.EventName} Event by ${await getUserById.call(userAuthId).then((user) => user.UserName)}',
      );
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

    if (widget.event.UserId != userAuthId) {
      if (widget.gift.GiftStatus != userAuthId) {
        _showError();
        return;
      }
    } else {
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

  Future<void> _editGift() async {
    // Prepopulate the fields with the current gift values
    giftNameController.text = widget.gift.GiftName;
    giftDescriptionController.text = widget.gift.GiftDescription ?? '';
    giftPriceController.text = widget.gift.GiftPrice.toString();
    selectedCategory = widget.gift.GiftCat;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text(
            'Edit Gift',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gift Name Input
                  TextField(
                    controller: giftNameController,
                    decoration: InputDecoration(
                      labelText: 'Gift Name',
                      prefixIcon: Icon(Icons.card_giftcard),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Gift Description Input
                  TextField(
                    controller: giftDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Gift Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Gift Price Input
                  TextField(
                    controller: giftPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Gift Price',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedCategory ?? categories.first,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Gift Category',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Row(
              children: [
                // Edit Gift Button
                Expanded(
                  child: IC_button(
                    title: 'Edit Gift',
                    onPress: () async {
                      if (giftNameController.text.isNotEmpty &&
                          giftPriceController.text.isNotEmpty) {
                        // Create updated gift
                        final updatedGift = GiftEntity(
                          GiftId: widget.gift.GiftId,
                          GiftName: giftNameController.text,
                          GiftDescription: giftDescriptionController.text,
                          GiftPrice: double.parse(giftPriceController.text),
                          GiftStatus: widget.gift.GiftStatus,
                          GiftCat: selectedCategory ?? 'Other',
                          GiftEventId: widget.event.EventId,
                        );

                        // Update gift using the use case
                        await updateGiftUseCase.call(updatedGift);

                        // Close dialog and update UI
                        Navigator.of(context).pop(updatedGift);
                        setState(() {
                          widget.gift = updatedGift;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gift Name and Price are mandatory'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.card_giftcard,
                      color: Colors.white,
                    ),
                    color: Colors.green,
                    fontsize: 14,
                    width: 150,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 5),
                // Cancel Button
                Expanded(
                  child: IC_button(
                    title: 'Cancel',
                    onPress: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    color: Colors.redAccent,
                    fontsize: 14,
                    width: 150,
                    height: 50,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGift() async {
    if (_isPledged) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Gift'),
            content:
                Text('You can\'t delete the gift details . (Already Pledged )'),
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
    } else {
      await deleteGiftUseCase.call(widget.gift);
      Navigator.pop(context);
    }
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
                      // Title: GIFT DETAILS
                      Text(
                        'GIFT DETAILS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Gift Details Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gift Name
                                Text(
                                  widget.gift.GiftName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Gift Description
                                Text(
                                  widget.gift.GiftDescription ??
                                      'No description available',
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 10),

                                // Gift Price
                                Text(
                                  'Price: ${widget.gift.GiftPrice.toStringAsFixed(2)} EGP',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Event Date
                                Text(
                                  'Event Date: ${widget.event.EventDate}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 10),

                                // Category Field
                                Text(
                                  'Category: ${widget.gift.GiftCat}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Pledged Information (via FutureBuilder)
                      FutureBuilder<String>(
                        future: getUserById
                            .call(widget.gift.GiftStatus)
                            .then((user) => user.UserName),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading...',
                              style: TextStyle(color: Colors.grey),
                            );
                          } else if (snapshot.hasData) {
                            return Text(
                              'Pledged by ${snapshot.data}',
                              style: const TextStyle(color: Colors.grey),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),

                      // Pledge/Unpledge Button
                      _isPledged
                          ? IC_button(
                              title: 'UnPledge',
                              icon: Icon(Icons.remove_circle_outline,
                                  color: AppColors.white),
                              onPress: _unpledgeGift,
                              color: Colors.grey,
                              fontsize: 14,
                              width: double.infinity,
                              height: 50,
                            )
                          : IC_button(
                              title: 'Pledge',
                              icon: Icon(Icons.add_box_rounded,
                                  color: AppColors.white),
                              onPress: _pledgeGift,
                              color: AppColors.secondary,
                              fontsize: 14,
                              width: double.infinity,
                              height: 50,
                            ),

                      SizedBox(height: 10),

                      // Edit and Delete Buttons (if the user is not the one who created the event)
                      widget.event.UserId != getUserAuthId.call()
                          ? Column(
                              children: [
                                IC_button(
                                  title: 'Edit Gift',
                                  icon:
                                      Icon(Icons.edit, color: AppColors.white),
                                  onPress: _editGift,
                                  color: Colors.blue,
                                  fontsize: 14,
                                  width: double.infinity,
                                  height: 50,
                                ),
                                SizedBox(height: 10),
                                IC_button(
                                  title: 'Delete Gift',
                                  icon: Icon(Icons.delete,
                                      color: AppColors.white),
                                  onPress: _deleteGift,
                                  color: Colors.red,
                                  fontsize: 14,
                                  width: double.infinity,
                                  height: 50,
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
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
