import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_place_app/helper/db_helper.dart';
import 'package:great_place_app/helper/location_helper.dart';
import 'package:great_place_app/models/place.dart';

class GreatPlaceProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final String address = await LocationHelper.getPlaceAddress(
        longitude: location.longitude, latitude: location.latitude);

    final updateLocation = PlaceLocation(
        longitude: location.longitude,
        latitude: location.latitude,
        address: address);

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updateLocation,
    );

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_place', {
      'id': newPlace.id,
      'image': newPlace.image.path,
      'title': newPlace.title,
      'loc_lat': newPlace.location.latitude,
      'loc_lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_place');
    _items = dataList
        .map((element) => Place(
            id: element['id'],
            title: element['title'],
            location: PlaceLocation(
              latitude: element['loc_lat'],
              longitude: element['loc_lng'],
              address: element['address'],
            ),
            image: File(element['image'])))
        .toList();
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
