import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan4.dart';
import '../providers/hec_layanan4s.dart';
// import '../providers/app_users.dart';

class EditHecLayanan4Screen extends StatefulWidget {
  static const routeName = '/edit-hec-layanan4';

  @override
  _EditLayanan4ScreenState createState() => _EditLayanan4ScreenState();
}

class _EditLayanan4ScreenState extends State<EditHecLayanan4Screen> {
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedItem = HecLayanan4(
    idHecLayanan4: null,
    namaHecLayanan4: '',
    kodeIcdHecLayanan4: '',
    harga1HecLayanan4: 0,
    harga2HecLayanan4: 0,
    jumlahHecLayanan4: 0,
    kodeBpjsHecLayanan4: '',
    tglBeliHecLayanan4: DateTime.now(),
  );

  var _initValues = {
    'idHecLayanan4': '',
    'namaHecLayanan4': '',
    'kodeIcdHecLayanan4': '',
    'harga1HecLayanan4': '0',
    'harga2HecLayanan4': '0',
    'jumlahHecLayanan4': '0',
    'kodeBpjsHecLayanan4': '000',
    'tglBeliHecLayanan4': DateFormat.yMMMd().format(DateTime.now()),
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedItem =
            Provider.of<HecLayanan4s>(context, listen: false).findById(queryId);
        _initValues = {
          'namaHecLayanan4': _editedItem.namaHecLayanan4,
          'kodeIcdHecLayanan4': _editedItem.kodeIcdHecLayanan4,
          'harga1HecLayanan4': _editedItem.harga1HecLayanan4.toString(),
          'harga2HecLayanan4': _editedItem.harga2HecLayanan4.toString(),
          'jumlahHecLayanan4': _editedItem.jumlahHecLayanan4.toString(),
          'kodeBpjsHecLayanan4': _editedItem.kodeBpjsHecLayanan4,
          'tglBeliHecLayanan4':
              DateFormat.yMMMd().format(_editedItem.tglBeliHecLayanan4),
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedItem.idHecLayanan4 != null) {
      await Provider.of<HecLayanan4s>(context, listen: false)
          .updateHecLayanan4(_editedItem.idHecLayanan4, _editedItem);
    } else {
      try {
        await Provider.of<HecLayanan4s>(context, listen: false)
            .addHecLayanan4(_editedItem);
      } catch (error) {
        // print(_editedItem.tglBeliHecLayanan4);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred'),
            content: Text('Something went wrong. >>> $error'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tindakan Operasi'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['namaHecLayanan4'],
                      decoration:
                          InputDecoration(labelText: 'Nama Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: value,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeIcdHecLayanan4'],
                      decoration: InputDecoration(
                          labelText: 'Kode ICD Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: value,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga1HecLayanan4'],
                      decoration:
                          InputDecoration(labelText: 'Harga1 Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: int.parse(value),
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga2HecLayanan4'],
                      decoration:
                          InputDecoration(labelText: 'Harga2 Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: int.parse(value),
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['jumlahHecLayanan4'],
                      decoration:
                          InputDecoration(labelText: 'Jumlah Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: int.parse(value),
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeBpjsHecLayanan4'],
                      decoration: InputDecoration(
                          labelText: 'Kode BPJS Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: value,
                          tglBeliHecLayanan4: _editedItem.tglBeliHecLayanan4,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tglBeliHecLayanan4'],
                      decoration: InputDecoration(
                          labelText: 'Tanggal Beli Tindakan Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan4(
                          idHecLayanan4: _editedItem.idHecLayanan4,
                          namaHecLayanan4: _editedItem.namaHecLayanan4,
                          kodeIcdHecLayanan4: _editedItem.kodeIcdHecLayanan4,
                          harga1HecLayanan4: _editedItem.harga1HecLayanan4,
                          harga2HecLayanan4: _editedItem.harga2HecLayanan4,
                          jumlahHecLayanan4: _editedItem.jumlahHecLayanan4,
                          kodeBpjsHecLayanan4: _editedItem.kodeBpjsHecLayanan4,
                          tglBeliHecLayanan4: DateFormat.yMMMd().parse(value),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
