import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_place_app/helper/location_helper.dart';
import 'package:great_place_app/screens/map_screen.dart';
import 'package:location/location.dart';

typedef OnSelectLocation(double lat, double lng);

class LocationInput extends StatefulWidget {
  final OnSelectLocation _onSelectLocation;

  const LocationInput(this._onSelectLocation);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locationData = await Location().getLocation();
      final imageUrl = LocationHelper.generateLocationPreviewImage(
          longitude: locationData.longitude, latitude: locationData.latitude);
      setState(() {
        _previewImageUrl = imageUrl;
      });
      widget._onSelectLocation(locationData.latitude, locationData.longitude);
    } catch (error) {
      // no permission etc...
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng selectLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
          builder: (ctx) => MapScreen(isSelecting: true)),);
    if (selectLocation == null) return;
    final imageUrl = LocationHelper.generateLocationPreviewImage(
        longitude: selectLocation.longitude, latitude: selectLocation.latitude);
    setState(() {
      _previewImageUrl = imageUrl;
    });
    widget._onSelectLocation(selectLocation.latitude, selectLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
