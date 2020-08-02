import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan3.dart';
import '../providers/hec_layanan3s.dart';
// import '../providers/app_users.dart';

class EditHecLayanan3Screen extends StatefulWidget {
  static const routeName = '/edit-hec-layanan3';

  @override
  _EditLayanan3ScreenState createState() => _EditLayanan3ScreenState();
}

class _EditLayanan3ScreenState extends State<EditHecLayanan3Screen> {
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedItem = HecLayanan3(
    idHecLayanan3: null,
    namaHecLayanan3: '',
    kodeIcdHecLayanan3: '',
    harga1HecLayanan3: 0,
    harga2HecLayanan3: 0,
    jumlahHecLayanan3: 0,
    kodeBpjsHecLayanan3: '',
    tglBeliHecLayanan3: DateTime.now(),
  );

  var _initValues = {
    'idHecLayanan3': '',
    'namaHecLayanan3': '',
    'kodeIcdHecLayanan3': '',
    'harga1HecLayanan3': '0',
    'harga2HecLayanan3': '0',
    'jumlahHecLayanan3': '0',
    'kodeBpjsHecLayanan3': '000',
    'tglBeliHecLayanan3': DateFormat.yMMMd().format(DateTime.now()),
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedItem =
            Provider.of<HecLayanan3s>(context, listen: false).findById(queryId);
        _initValues = {
          'namaHecLayanan3': _editedItem.namaHecLayanan3,
          'kodeIcdHecLayanan3': _editedItem.kodeIcdHecLayanan3,
          'harga1HecLayanan3': _editedItem.harga1HecLayanan3.toString(),
          'harga2HecLayanan3': _editedItem.harga2HecLayanan3.toString(),
          'jumlahHecLayanan3': _editedItem.jumlahHecLayanan3.toString(),
          'kodeBpjsHecLayanan3': _editedItem.kodeBpjsHecLayanan3,
          'tglBeliHecLayanan3':
              DateFormat.yMMMd().format(_editedItem.tglBeliHecLayanan3),
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
    if (_editedItem.idHecLayanan3 != null) {
      await Provider.of<HecLayanan3s>(context, listen: false)
          .updateHecLayanan3(_editedItem.idHecLayanan3, _editedItem);
    } else {
      try {
        await Provider.of<HecLayanan3s>(context, listen: false)
            .addHecLayanan3(_editedItem);
      } catch (error) {
        // print(_editedItem.tglBeliHecLayanan3);
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
        title: Text('Edit Medikamentosa'),
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
                      initialValue: _initValues['namaHecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Nama Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: value,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeIcdHecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Kode ICD Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: value,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga1HecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Harga1 Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: int.parse(value),
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga2HecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Harga2 Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: int.parse(value),
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['jumlahHecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Jumlah Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: int.parse(value),
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeBpjsHecLayanan3'],
                      decoration:
                          InputDecoration(labelText: 'Kode BPJS Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: value,
                          tglBeliHecLayanan3: _editedItem.tglBeliHecLayanan3,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tglBeliHecLayanan3'],
                      decoration: InputDecoration(
                          labelText: 'Tanggal Beli Medikamentosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan3(
                          idHecLayanan3: _editedItem.idHecLayanan3,
                          namaHecLayanan3: _editedItem.namaHecLayanan3,
                          kodeIcdHecLayanan3: _editedItem.kodeIcdHecLayanan3,
                          harga1HecLayanan3: _editedItem.harga1HecLayanan3,
                          harga2HecLayanan3: _editedItem.harga2HecLayanan3,
                          jumlahHecLayanan3: _editedItem.jumlahHecLayanan3,
                          kodeBpjsHecLayanan3: _editedItem.kodeBpjsHecLayanan3,
                          tglBeliHecLayanan3: DateFormat.yMMMd().parse(value),
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
