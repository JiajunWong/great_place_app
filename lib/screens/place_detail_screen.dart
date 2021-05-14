import 'package:flutter/material.dart';
import 'package:great_place_app/provider/great_place_provider.dart';
import 'package:great_place_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';

  const PlaceDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final placeData =
        Provider.of<GreatPlaceProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(placeData.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              placeData.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            placeData.location.address,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                        isSelecting: false,
                        initialLocation: placeData.location,
                      )));
            },
            child: Text('View On Map'),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
