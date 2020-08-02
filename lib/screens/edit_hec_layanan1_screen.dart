import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan1.dart';
import '../providers/hec_layanan1s.dart';
// import '../providers/app_users.dart';

class EditHecLayanan1Screen extends StatefulWidget {
  static const routeName = '/edit-hec-layanan1';

  @override
  _EditLayanan1ScreenState createState() => _EditLayanan1ScreenState();
}

class _EditLayanan1ScreenState extends State<EditHecLayanan1Screen> {
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedItem = HecLayanan1(
    idHecLayanan1: null,
    namaHecLayanan1: '',
    kodeIcdHecLayanan1: '',
    harga1HecLayanan1: 0,
    harga2HecLayanan1: 0,
    jumlahHecLayanan1: 0,
    kodeBpjsHecLayanan1: '',
    tglBeliHecLayanan1: DateTime.now(),
  );

  var _initValues = {
    'idHecLayanan1': '',
    'namaHecLayanan1': '',
    'kodeIcdHecLayanan1': '',
    'harga1HecLayanan1': '0',
    'harga2HecLayanan1': '0',
    'jumlahHecLayanan1': '0',
    'kodeBpjsHecLayanan1': '000',
    'tglBeliHecLayanan1': DateFormat.yMMMd().format(DateTime.now()),
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedItem =
            Provider.of<HecLayanan1s>(context, listen: false).findById(queryId);
        _initValues = {
          'namaHecLayanan1': _editedItem.namaHecLayanan1,
          'kodeIcdHecLayanan1': _editedItem.kodeIcdHecLayanan1,
          'harga1HecLayanan1': _editedItem.harga1HecLayanan1.toString(),
          'harga2HecLayanan1': _editedItem.harga2HecLayanan1.toString(),
          'jumlahHecLayanan1': _editedItem.jumlahHecLayanan1.toString(),
          'kodeBpjsHecLayanan1': _editedItem.kodeBpjsHecLayanan1,
          'tglBeliHecLayanan1':
              DateFormat.yMMMd().format(_editedItem.tglBeliHecLayanan1),
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
    if (_editedItem.idHecLayanan1 != null) {
      await Provider.of<HecLayanan1s>(context, listen: false)
          .updateHecLayanan1(_editedItem.idHecLayanan1, _editedItem);
    } else {
      try {
        await Provider.of<HecLayanan1s>(context, listen: false)
            .addHecLayanan1(_editedItem);
      } catch (error) {
        // print(_editedItem.tglBeliHecLayanan1);
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
        title: Text('Edit Tindakan Non Operasi'),
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
                      initialValue: _initValues['namaHecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Nama Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: value,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeIcdHecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Kode ICD Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: value,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga1HecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Harga1 Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: int.parse(value),
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga2HecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Harga2 Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: int.parse(value),
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['jumlahHecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Jumlah Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: int.parse(value),
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeBpjsHecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Kode BPJS Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: value,
                          tglBeliHecLayanan1: _editedItem.tglBeliHecLayanan1,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tglBeliHecLayanan1'],
                      decoration: InputDecoration(
                          labelText: 'Tanggal Beli Tindakan Non Operasi'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan1(
                          idHecLayanan1: _editedItem.idHecLayanan1,
                          namaHecLayanan1: _editedItem.namaHecLayanan1,
                          kodeIcdHecLayanan1: _editedItem.kodeIcdHecLayanan1,
                          harga1HecLayanan1: _editedItem.harga1HecLayanan1,
                          harga2HecLayanan1: _editedItem.harga2HecLayanan1,
                          jumlahHecLayanan1: _editedItem.jumlahHecLayanan1,
                          kodeBpjsHecLayanan1: _editedItem.kodeBpjsHecLayanan1,
                          tglBeliHecLayanan1: DateFormat.yMMMd().parse(value),
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
