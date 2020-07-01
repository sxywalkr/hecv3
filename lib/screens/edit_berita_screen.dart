import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/berita.dart';
import '../providers/beritas.dart';

class EditBeritaScreen extends StatefulWidget {
  static const routeName = '/edit-berita';

  @override
  _EditBeritaScreenState createState() => _EditBeritaScreenState();
}

class _EditBeritaScreenState extends State<EditBeritaScreen> {
  // final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Berita(
    id: null,
    title: '',
    imageUrl: '',
    description: '',
  );

  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Beritas>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          // 'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    // _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
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
    if (_editedProduct.id != null) {
      await Provider.of<Beritas>(context, listen: false)
          .updateBerita(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Beritas>(context, listen: false)
            .addBerita(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error occurred'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      //   finally {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //     Navigator.of(context).pop();
      //   }
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
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
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
                        _editedProduct = Berita(
                          title: value,
                          // price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    // TextFormField(
                    //   initialValue: _initValues['price'],
                    //   decoration: InputDecoration(labelText: 'Price'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   focusNode: _priceFocusNode,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context)
                    //         .requestFocus(_descriptionFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please enter a price';
                    //     }
                    //     if (double.tryParse(value) == null) {
                    //       return 'Please enter a valid number';
                    //     }
                    //     if (double.parse(value) <= 0) {
                    //       return 'Please enter a number > 0';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Berita(
                    //       title: _editedProduct.title,
                    //       // price: double.parse(value),
                    //       imageUrl: _editedProduct.imageUrl,
                    //       description: _editedProduct.description,
                    //       id: _editedProduct.id,
                    //       isFavorite: _editedProduct.isFavorite,
                    //     );
                    //   },
                    // ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter description';
                        }
                        if (value.length < 10) {
                          return 'Should be > 10 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Berita(
                          title: _editedProduct.title,
                          // price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                          description: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            color: Colors.grey,
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter image url')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide an image url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please provide an valid image url';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Berita(
                                title: _editedProduct.title,
                                // price: _editedProduct.price,
                                imageUrl: value,
                                description: _editedProduct.description,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
