import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:xlife/helpers/constants.dart';
import 'package:xlife/helpers/fcm.dart';
import 'package:xlife/views/layouts/layout_user_all_events.dart';
import 'package:xlife/views/layouts/layout_user_favorite_events.dart';
import 'package:xlife/views/layouts/layout_user_news_feed.dart';
import 'package:xlife/views/layouts/layout_user_search_events_by_organizers.dart';
import 'package:xlife/widgets/custom_bottom_navigation.dart';
import 'package:xlife/widgets/custom_home_header_container_design.dart';

class ScreenUserHomepage extends StatefulWidget {
  ScreenUserHomepage({Key? key}) : super(key: key);

  @override
  _ScreenUserHomepageState createState() => _ScreenUserHomepageState();
}

class _ScreenUserHomepageState extends State<ScreenUserHomepage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    LayoutUserAllEvents(),
    LayoutUserSearchEventsByOrganizers(),
    LayoutUserFavoriteEvents(),
    LayoutUserNewsFeed(),
  ];
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final location = loc.Location();

  @override
  void initState() {
    _checkLocationPermissions();
    location.enableBackgroundMode(enable: true);
    _getCurrentLocation();
    updateLastSeenAndToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomHomeHeaderContainerDesign(
        image_url: "",
        child: pages[selectedIndex],
        bottomNavigationBar: CustomBottomNavigation(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          showSelectedLabels: false,
          type: CustomBottomNavigationType.animating,
          showUnselectedLabels: false,
          selectedItemColor: appPrimaryColor,
          unselectedItemColor: Colors.black26,
          items: [
            CustomBottomMenuItem(
              label: "Nearby Events",
              icon: ImageIcon(AssetImage("assets/images/multiple_events.png")),
            ),
            CustomBottomMenuItem(
              label: "Search",
              icon: ImageIcon(AssetImage("assets/images/search_events.png")),
            ),
            CustomBottomMenuItem(
              label: "Favorites",
              icon: ImageIcon(AssetImage("assets/images/star.png")),
            ),
            CustomBottomMenuItem(
              label: "News Feed",
              icon: ImageIcon(AssetImage("assets/images/newsfeed.png")),
            ),
          ],
          primaryIndex: 0,
        ),
        type: HomePageType.user,
      ),
    );
  }

  Future<void> updateLastSeenAndToken() async {
    int last_seen = DateTime.now().millisecondsSinceEpoch;
    String? token = await FCM.generateToken();
    usersRef.doc(uid).update({"last_seen": last_seen, "notificationToken": token});
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      int last_seen = DateTime.now().millisecondsSinceEpoch;
      usersRef.doc(uid).update({"last_seen": last_seen});
    });
  }

  Future<void> _checkLocationPermissions() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
      return;
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        _checkLocationPermissions();
      }
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    var _serviceEnabled = await location.serviceEnabled();
    location.changeSettings(interval: 10000);
    location.onLocationChanged.listen((loc.LocationData currentLocation) {
      print(currentLocation);
      usersRef.doc(uid).update({"latitude": currentLocation.latitude, "longitude": currentLocation.longitude});
    });
    Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.low,
    )).listen((currentLocation) {
      if (mounted){
        setState(() {
          currentPosition = currentLocation;
        });
      }
      usersRef.doc(uid).update({"latitude": currentLocation.latitude, "longitude": currentLocation.longitude});
    });
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }
}
