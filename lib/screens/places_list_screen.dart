import 'package:flutter/material.dart';
import 'package:great_place_app/provider/great_place_provider.dart';
import 'package:great_place_app/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              }),
        ],
      ),
      body: Consumer<GreatPlaceProvider>(
        child: Center(
          child: Text('No place yet. Please add one.'),
        ),
        builder: (ctx, placeData, child) => placeData.items.length == 0
            ? child
            : ListView.builder(
                itemBuilder: (ctx, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(placeData.items[index].image),
                  ),
                  title: Text(placeData.items[index].title),
                  onTap: () {},
                ),
                itemCount: placeData.items.length,
              ),
      ),
    );
  }
}
