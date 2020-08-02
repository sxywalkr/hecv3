import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan2.dart';
import '../providers/hec_layanan2s.dart';
// import '../providers/app_users.dart';

class EditHecLayanan2Screen extends StatefulWidget {
  static const routeName = '/edit-hec-layanan2';

  @override
  _EditLayanan2ScreenState createState() => _EditLayanan2ScreenState();
}

class _EditLayanan2ScreenState extends State<EditHecLayanan2Screen> {
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedItem = HecLayanan2(
    idHecLayanan2: null,
    namaHecLayanan2: '',
    kodeIcdHecLayanan2: '',
    harga1HecLayanan2: 0,
    harga2HecLayanan2: 0,
    jumlahHecLayanan2: 0,
    kodeBpjsHecLayanan2: '',
    tglBeliHecLayanan2: DateTime.now(),
  );

  var _initValues = {
    'idHecLayanan2': '',
    'namaHecLayanan2': '',
    'kodeIcdHecLayanan2': '',
    'harga1HecLayanan2': '0',
    'harga2HecLayanan2': '0',
    'jumlahHecLayanan2': '0',
    'kodeBpjsHecLayanan2': '000',
    'tglBeliHecLayanan2': DateFormat.yMMMd().format(DateTime.now()),
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedItem =
            Provider.of<HecLayanan2s>(context, listen: false).findById(queryId);
        _initValues = {
          'namaHecLayanan2': _editedItem.namaHecLayanan2,
          'kodeIcdHecLayanan2': _editedItem.kodeIcdHecLayanan2,
          'harga1HecLayanan2': _editedItem.harga1HecLayanan2.toString(),
          'harga2HecLayanan2': _editedItem.harga2HecLayanan2.toString(),
          'jumlahHecLayanan2': _editedItem.jumlahHecLayanan2.toString(),
          'kodeBpjsHecLayanan2': _editedItem.kodeBpjsHecLayanan2,
          'tglBeliHecLayanan2':
              DateFormat.yMMMd().format(_editedItem.tglBeliHecLayanan2),
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
    if (_editedItem.idHecLayanan2 != null) {
      await Provider.of<HecLayanan2s>(context, listen: false)
          .updateHecLayanan2(_editedItem.idHecLayanan2, _editedItem);
    } else {
      try {
        await Provider.of<HecLayanan2s>(context, listen: false)
            .addHecLayanan2(_editedItem);
      } catch (error) {
        // print(_editedItem.tglBeliHecLayanan2);
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
        title: Text('Edit Diagnosa'),
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
                      initialValue: _initValues['namaHecLayanan2'],
                      decoration: InputDecoration(labelText: 'Nama Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: value,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeIcdHecLayanan2'],
                      decoration:
                          InputDecoration(labelText: 'Kode ICD Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: value,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga1HecLayanan2'],
                      decoration: InputDecoration(labelText: 'Harga1 Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: int.parse(value),
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga2HecLayanan2'],
                      decoration: InputDecoration(labelText: 'Harga2 Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: int.parse(value),
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['jumlahHecLayanan2'],
                      decoration: InputDecoration(labelText: 'Jumlah Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: int.parse(value),
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeBpjsHecLayanan2'],
                      decoration:
                          InputDecoration(labelText: 'Kode BPJS Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: value,
                          tglBeliHecLayanan2: _editedItem.tglBeliHecLayanan2,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tglBeliHecLayanan2'],
                      decoration:
                          InputDecoration(labelText: 'Tanggal Beli Diagnosa'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan2(
                          idHecLayanan2: _editedItem.idHecLayanan2,
                          namaHecLayanan2: _editedItem.namaHecLayanan2,
                          kodeIcdHecLayanan2: _editedItem.kodeIcdHecLayanan2,
                          harga1HecLayanan2: _editedItem.harga1HecLayanan2,
                          harga2HecLayanan2: _editedItem.harga2HecLayanan2,
                          jumlahHecLayanan2: _editedItem.jumlahHecLayanan2,
                          kodeBpjsHecLayanan2: _editedItem.kodeBpjsHecLayanan2,
                          tglBeliHecLayanan2: DateFormat.yMMMd().parse(value),
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
