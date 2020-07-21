import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_user.dart';
import '../providers/app_users.dart';

class EditAppUserScreen extends StatefulWidget {
  static const routeName = '/edit-app-user';

  @override
  _EditAppUserScreenState createState() => _EditAppUserScreenState();
}

class _EditAppUserScreenState extends State<EditAppUserScreen> {
  final _descriptionFocusNode = FocusNode();
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = AppUser(
    appUserId: null,
    nama: '',
    email: '',
    noRmHec: '',
    noKtp: '',
    noBpjs: '',
    noHape: '',
    gender: '',
    alamat: '',
    tanggalLahir: DateTime.now(),
    flagActivity: '',
    statusAppUser: '',
    appUserRole: '',
  );

  var _initValues = {
    'nama': '',
    'email': '',
    'noRmHec': '',
    'noKtp': '',
    'noBpjs': '',
    'noHape': '',
    'gender': '',
    'alamat': '',
    'tanggalLahir': 'Jan 1, 1990',
    'statusAppUser': 'BPJS',
    'flagActivity': 'idle',
    'appUserRole': 'Anom',
  };

  @override
  void initState() {
    // _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final queryId = ModalRoute.of(context).settings.arguments as String;
      if (queryId != null) {
        _editedProduct =
            Provider.of<AppUsers>(context, listen: false).findById(queryId);
        _initValues = {
          'nama': _editedProduct.nama,
          'email': _editedProduct.email,
          'noRmHec': _editedProduct.noRmHec,
          'noKtp': _editedProduct.noKtp,
          'noBpjs': _editedProduct.noBpjs,
          'noHape': _editedProduct.noHape,
          'gender': _editedProduct.gender,
          'alamat': _editedProduct.alamat,
          'statusAppUser': _editedProduct.statusAppUser,
          'tanggalLahir':
              DateFormat.yMMMd().format(_editedProduct.tanggalLahir),
          'appUserRole': _editedProduct.appUserRole,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
    super.dispose();
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
    if (_editedProduct.appUserId != null) {
      await Provider.of<AppUsers>(context, listen: false)
          .updateAppUser(_editedProduct.appUserId, _editedProduct);
    } else {
      try {
        await Provider.of<AppUsers>(context, listen: false)
            .addAppUser(_editedProduct);
      } catch (error) {
        // print(_editedProduct.tanggalLahir);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred'),
            content: Text('Something went wrong. $error'),
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
        title: Text('Edit Berita'),
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
                      initialValue: _initValues['nama'],
                      decoration: InputDecoration(labelText: 'Nama'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: value,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: value,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['noRmHec'],
                      decoration:
                          InputDecoration(labelText: 'Nomor Rekam Medik HEC'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: value,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['noKtp'],
                      decoration: InputDecoration(labelText: 'Nomor KTP'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: value,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['noBpjs'],
                      decoration: InputDecoration(labelText: 'Nomor BPJS'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: value,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['noHape'],
                      decoration: InputDecoration(labelText: 'Nomor Handphone'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: value,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['gender'],
                      decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: value,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['alamat'],
                      decoration: InputDecoration(labelText: 'Alamat'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: value,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['tanggalLahir'],
                      decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          // tanggalLahir: DateFormat.yMMMd().parse(value),
                          tanggalLahir: DateFormat.yMMMd().parse(value),
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['statusAppUser'],
                      decoration: InputDecoration(labelText: 'Status'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: value,
                          flagActivity: 'idle',
                          appUserRole: _editedProduct.appUserRole,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['appUserRole'],
                      decoration: InputDecoration(labelText: 'User Role'),
                      textInputAction: TextInputAction.next,
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = AppUser(
                          appUserId: _editedProduct.appUserId,
                          nama: _editedProduct.nama,
                          email: _editedProduct.email,
                          noRmHec: _editedProduct.noRmHec,
                          noKtp: _editedProduct.noKtp,
                          noBpjs: _editedProduct.noBpjs,
                          noHape: _editedProduct.noHape,
                          gender: _editedProduct.gender,
                          alamat: _editedProduct.alamat,
                          tanggalLahir: _editedProduct.tanggalLahir,
                          statusAppUser: _editedProduct.statusAppUser,
                          flagActivity: 'idle',
                          appUserRole: value,
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
