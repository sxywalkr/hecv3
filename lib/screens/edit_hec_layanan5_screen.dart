import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/hec_layanan5.dart';
import '../providers/hec_layanan5s.dart';

class EditHecLayanan5Screen extends StatefulWidget {
  static const routeName = '/edit-hec-layanan5';

  @override
  _EditLayanan5ScreenState createState() => _EditLayanan5ScreenState();
}

class _EditLayanan5ScreenState extends State<EditHecLayanan5Screen> {
  final _form = GlobalKey<FormState>();

  var _editedItem = HecLayanan5(
    idHecLayanan5: null,
    namaHecLayanan5: '',
    kodeIcdHecLayanan5: '',
    harga1HecLayanan5: 0,
    harga2HecLayanan5: 0,
    jumlahHecLayanan5: 0,
    kodeBpjsHecLayanan5: '',
    tglBeliHecLayanan5: DateTime.now(),
  );

  var _initValues = {
    'idHecLayanan5': '',
    'namaHecLayanan5': '',
    'kodeIcdHecLayanan5': '',
    'harga1HecLayanan5': '0',
    'harga2HecLayanan5': '0',
    'jumlahHecLayanan5': '0',
    'kodeBpjsHecLayanan5': '000',
    'tglBeliHecLayanan5': DateFormat.yMMMd().format(DateTime.now()),
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedItem =
            Provider.of<HecLayanan5s>(context, listen: false).findById(queryId);
        _initValues = {
          'namaHecLayanan5': _editedItem.namaHecLayanan5,
          'kodeIcdHecLayanan5': _editedItem.kodeIcdHecLayanan5,
          'harga1HecLayanan5': _editedItem.harga1HecLayanan5.toString(),
          'harga2HecLayanan5': _editedItem.harga2HecLayanan5.toString(),
          'jumlahHecLayanan5': _editedItem.jumlahHecLayanan5.toString(),
          'kodeBpjsHecLayanan5': _editedItem.kodeBpjsHecLayanan5,
          'tglBeliHecLayanan5':
              DateFormat.yMMMd().format(_editedItem.tglBeliHecLayanan5),
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
    if (_editedItem.idHecLayanan5 != null) {
      await Provider.of<HecLayanan5s>(context, listen: false)
          .updateHecLayanan5(_editedItem.idHecLayanan5, _editedItem);
    } else {
      try {
        await Provider.of<HecLayanan5s>(context, listen: false)
            .addHecLayanan5(_editedItem);
      } catch (error) {
        // print(_editedItem.tglBeliHecLayanan5);
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
        title: Text('Edit Kacamata'),
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
                      initialValue: _initValues['namaHecLayanan5'],
                      decoration: InputDecoration(labelText: 'Nama Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: value,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeIcdHecLayanan5'],
                      decoration:
                          InputDecoration(labelText: 'Kode ICD Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: value,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga1HecLayanan5'],
                      decoration: InputDecoration(labelText: 'Harga1 Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: int.parse(value),
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['harga2HecLayanan5'],
                      decoration: InputDecoration(labelText: 'Harga2 Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: int.parse(value),
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['jumlahHecLayanan5'],
                      decoration: InputDecoration(labelText: 'Jumlah Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: int.parse(value),
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['kodeBpjsHecLayanan5'],
                      decoration:
                          InputDecoration(labelText: 'Kode BPJS Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: value,
                          tglBeliHecLayanan5: _editedItem.tglBeliHecLayanan5,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tglBeliHecLayanan5'],
                      decoration:
                          InputDecoration(labelText: 'Tanggal Beli Kacamata'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedItem = HecLayanan5(
                          idHecLayanan5: _editedItem.idHecLayanan5,
                          namaHecLayanan5: _editedItem.namaHecLayanan5,
                          kodeIcdHecLayanan5: _editedItem.kodeIcdHecLayanan5,
                          harga1HecLayanan5: _editedItem.harga1HecLayanan5,
                          harga2HecLayanan5: _editedItem.harga2HecLayanan5,
                          jumlahHecLayanan5: _editedItem.jumlahHecLayanan5,
                          kodeBpjsHecLayanan5: _editedItem.kodeBpjsHecLayanan5,
                          tglBeliHecLayanan5: DateFormat.yMMMd().parse(value),
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
