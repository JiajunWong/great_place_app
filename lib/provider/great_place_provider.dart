import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_place_app/helper/db_helper.dart';
import 'package:great_place_app/models/place.dart';

class GreatPlaceProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(
    String title,
    File image,
  ) async {
    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: null,
    );

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_place', {
      'id': newPlace.id,
      'image': newPlace.image.path,
      'title': newPlace.title,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_place');
    _items = dataList
        .map((element) => Place(
            id: element['id'],
            title: element['title'],
            location: null,
            image: File(element['image'])))
        .toList();
    notifyListeners();
  }
}
