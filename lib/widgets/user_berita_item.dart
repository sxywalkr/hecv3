import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/beritas.dart';
import '../screens/edit_berita_screen.dart';

class UserBeritaItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserBeritaItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditBeritaScreen.routeName,
                arguments: id,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () async {
              try {
                await Provider.of<Beritas>(context, listen: false)
                    .deleteBerita(id);
              } catch (error) {
                scaffold.showSnackBar(SnackBar(
                  content: Text(
                    'Deleting failed',
                    textAlign: TextAlign.center,
                  ),
                ));
              }
            },
          ),
        ]),
      ),
    );
  }
}
