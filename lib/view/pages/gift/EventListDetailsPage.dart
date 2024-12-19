import 'dart:async';

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

import '../../../data/database/local/sqlite_barcode_dao.dart';
import '../../../data/database/local/sqlite_user_dao.dart';
import '../../../data/database/remote/firebase_auth.dart';
import '../../../data/database/remote/firebase_user_dao.dart';
import '../../../data/models/gift.dart';
import '../../../data/repos/user_repository_impl.dart';
import '../../../domain/usecases/gifts/getStreamGift.dart';
import '../../../domain/usecases/user/getUserbyId.dart';
import '../../../utils/Barcode/BarcodeScanner.dart';
import '../../../utils/RandomIdGenerator.dart';
import '../../components/widgets/buttons/IconButton.dart';
import '../../components/widgets/nav/CustomAppBar.dart';
import 'GiftDetailsPage.dart';

class EventDetails extends StatefulWidget {
  final EventEntity event;

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final ScrollController _controller = ScrollController();
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

  late GetStreamGift getGiftsStream;
  late Stream<List<GiftEntity>> giftsStream;
  late StreamSubscription<List<GiftEntity>>? _giftsSubscription;
  List<GiftEntity> gifts = [];

  String PledgedUserId = '' ;

  @override
  void initState() {
    super.initState();
    _initializeGifts();
    _subscribeToGifts();
  }

  late GetGiftsEvent getGiftsEvent;
  late AddGift addGift;
  late SyncGifts syncGifts;


  late GetUserById getUserById;

  Future<void> _initializeGifts() async {
    try {
      final sqlitegiftDataSource = SQLiteGiftDataSource();
      final firebasegiftDataSource = FirebaseGiftDataSource();

      final giftRepository = GiftRepositoryImpl(
        sqliteDataSource: sqlitegiftDataSource,
        firebaseDataSource: firebasegiftDataSource,
      );


      final sqliteDataSource = SQLiteUserDataSource();
      final firebaseDataSource = FirebaseUserDataSource();
      final firebaseAuthDataSource = FirebaseAuthDataSource();
      final userRepository = UserRepositoryImpl(
        sqliteDataSource: sqliteDataSource,
        firebaseDataSource: firebaseDataSource,
        firebaseAuthDataSource: firebaseAuthDataSource,
      );

      getUserById = GetUserById(userRepository);

      getGiftsStream = GetStreamGift(giftRepository);
      addGift = AddGift(giftRepository);

    } catch (e) {
      debugPrint('Error during initialization: $e');
    }
  }

  void _subscribeToGifts() {
    // giftsStream = getGiftsStream.call(widget.event.EventId);
    //
    // _giftsSubscription = giftsStream.listen((updatedGifts) {
    //   print('Gifts updated: $updatedGifts');
    //   setState(() {
    //     gifts = updatedGifts;
    //   });
    // });
    giftsStream = getGiftsStream.call(widget.event.EventId);

    _giftsSubscription = giftsStream.listen((updatedGifts) {
      print('Gifts updated: $updatedGifts');
      if (mounted) {
        setState(() {
          gifts = updatedGifts;
        });
      }
    });
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _giftsSubscription?.cancel();
    _subscribeToGifts();
  }

  @override
  void dispose() {
    _giftsSubscription?.cancel();
    super.dispose();
  }

  Future<void> _addGiftManually() async {
    final giftNameController = TextEditingController();
    final giftDescriptionController = TextEditingController();
    final giftPriceController = TextEditingController();
    String? selectedCategory;

    final GiftEntity? added = await showDialog<GiftEntity>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          title: Text(
            'Add Gift',
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
                  TextField(
                    controller: giftNameController,
                    decoration: InputDecoration(
                      labelText: 'Gift Name',
                      prefixIcon: Icon(Icons.card_giftcard),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: giftDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Gift Description',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
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
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
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
                Expanded(
                  child: IC_button(
                    title: 'Add Gift',
                    onPress: () {
                      if (giftNameController.text.isNotEmpty &&
                          giftPriceController.text.isNotEmpty) {
                        final gift = GiftEntity(
                          GiftId: randomAlphaNumeric(
                              DateTime.now().millisecondsSinceEpoch % 100),
                          GiftName: giftNameController.text,
                          GiftDescription: giftDescriptionController.text,
                          GiftPrice:
                              double.tryParse(giftPriceController.text) ?? 0.0,
                          GiftCat: selectedCategory ?? 'Other',
                          GiftStatus: 'Available',
                          GiftEventId: widget.event.EventId,
                        );
                        Navigator.pop(context, gift);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Gift Name and Price are mandatory')),
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
            )
          ],
        );
      },
    );

    giftNameController.dispose();
    giftDescriptionController.dispose();
    giftPriceController.dispose();

    if (added == null) {
      print('No gift added');
      return;
    }

    print('Added gift: ${added.GiftName}');

    try {
      await addGift.call(added);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gift added successfully')),
      );
      print('Gift added successfully');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add gift: $e')),
      );
      print('Failed to add gift: $e');
    }
  }


  Future<void> _addGiftUsingBarcode() async {
    // Navigate to the BarcodeScanner screen and get the scanned barcode (added).
    final String? added = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerWithScanWindow(),
      ),
    );

    // Check if the barcode was scanned, if not return early.
    if (added == null) {
      print('No barcode scanned');
      return;
    }

    print('Added gift: $added');

    // Initialize the barcode data source for retrieving gift details.
    final _barcode = SQLiteBarcodeDataSource();

    // Fetch the gift details from the database using the barcode.
    Gift? gift = await _barcode.getGift(added);

    // Check if gift is null, handle this case appropriately.
    if (gift == null) {
      print('Gift not found for barcode: $added');
      return;
    }

    // If gift is found, print gift details.
    print('Gift Details: ${gift.GiftName}');

    // Create a GiftEntity to be saved to the database.
    GiftEntity giftEntity = GiftEntity(
      GiftId: randomAlphaNumeric(DateTime.now().millisecondsSinceEpoch % 100),
      GiftName: gift.GiftName,
      GiftDescription: gift.GiftDescription,
      GiftPrice: gift.GiftPrice,
      GiftCat: gift.GiftCat,
      GiftStatus: gift.GiftStatus,
      GiftEventId: widget.event.EventId,
    );

    // Add the gift entity to the database.
    try {
      await addGift.call(giftEntity);

      print('Gift added successfully');
    } catch (e) {
      print('Failed to add gift: $e');
    }
  }

  void _addGift() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // This allows the modal to resize for the keyboard
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Title above the buttons
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Choose an Option', // Your title here
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Column(
                  children: [
                    IC_button(
                      title: 'Add Manually',
                      onPress: () {
                        Navigator.pop(context);
                        _addGiftManually();
                      },
                      icon: const Icon(
                        Icons.keyboard_alt,
                        color: Colors.white,
                      ),
                      color: AppColors.primary,
                      fontsize: 14,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                    SizedBox(height: 10),
                    IC_button(
                      title: 'Using Barcode',
                      onPress: _addGiftUsingBarcode,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      color: Colors.green,
                      fontsize: 14,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
                          'EVENT DETAILS',
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
                                    widget.event.EventName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'By: ${widget.event.UserName}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(widget.event.EventDescription),
                                  SizedBox(height: 5),
                                  Text(
                                    'Date: ${widget.event.EventDate}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                  itemCount: gifts.length, // Make sure `gifts` is a defined list
                  itemBuilder: (context, index) {
                    final gift = gifts[index]; // Assuming `gifts` is a list of gift objects
                    return Card(
                      color: gift.GiftStatus == 'Available' ?  Colors.white: Colors.green[50],
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


                        subtitle: gift.GiftStatus == 'Available'
                            ? const Text(
                                'Available',
                                style: TextStyle(color: Colors.grey),
                              )
                            :
                        FutureBuilder<String>(
                          future: getUserById.call(gift.GiftStatus).then((user) => user.UserName),
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
                              return const Text(
                                'Failed to load user',
                                style: TextStyle(color: Colors.red),
                              );
                            }
                          },
                        ),
                        trailing: Text(
                          '${gift.GiftPrice.toString()} EGP',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () async {
                          // Handle the tap event
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GiftDetailsPage(event: widget.event , gift: gift),
                            ),
                          );
                        },
                      ),

                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: DateTime.tryParse(widget.event.EventDate)!.isAfter(DateTime.now()) && widget.event.UserName == 'Me'
          ? FloatingActionButton(
              onPressed: () {
                _addGift();
              },
              child: const Icon(
                Icons.add_task,
                color: Colors.white,
              ),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}
