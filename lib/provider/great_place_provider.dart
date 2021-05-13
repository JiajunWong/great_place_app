import 'package:flutter/foundation.dart';
import 'package:great_place_app/models/place.dart';

class GreatPlaceProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }


}
