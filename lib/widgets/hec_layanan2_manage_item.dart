import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan2s.dart';
import '../screens/edit_hec_layanan2_screen.dart';

class HecLayanan2ManageItem extends StatelessWidget {
  final String id;
  final String nama;
  final int jumlah;

  HecLayanan2ManageItem(this.id, this.nama, this.jumlah);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(nama),
      // leading: CircleAvatar(
      //     // backgroundImage: NetworkImage(jumlah),
      //     ),
      trailing: Container(
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditHecLayanan2Screen.routeName,
                arguments: id,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () async {
              try {
                await Provider.of<HecLayanan2s>(context, listen: false)
                    .deleteHecLayanan2(id);
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
