import 'package:binary_music_tools/blocs/brew_db/bloc.dart';
import 'package:binary_music_tools/models/brew.dart';
import 'package:binary_music_tools/widgets/brew_detail_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrewsList extends StatelessWidget {
  final List<Brew> brews;

  const BrewsList({Key key, @required this.brews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: brews.length,
      itemBuilder: (context, index) {
        var brew = brews[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(brew.name),
              trailing: Icon(Icons.local_drink),
              subtitle: BrewDetailList(brew: brew),
              onLongPress: () => _showDeleteBrewDialog(context, brew),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteBrewDialog(BuildContext context, Brew brew) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Brew '${brew.name}' löschen?"),
          content: new Text(
              "Bist du sicher dass du dieses Bier löschen willst? Das kann nicht rückgängig gemacht werden!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Löschen"),
              onPressed: () {
                context.bloc<BrewDbBloc>().add(DeleteBrew(brew.id));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
