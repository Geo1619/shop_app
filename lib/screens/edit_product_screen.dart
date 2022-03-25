import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

import '../providers/product_data.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  // GlobalKey is needed to interact with the Form widget
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // add listener to update image preview when url textfield loses focus
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductData>(context, listen: false).getById(productId);
        // set intial value of controller. Cannot use initialValue field of TextFormField
        // if it has a controller
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // nodes, controllers and listeners should be disposed to avoid memory leaks
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _titleFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var isValidForm = _formKey.currentState?.validate();
    if (!isValidForm!) {
      return;
    }
    _formKey.currentState?.save();
    // inform widget to rebuild so loading circle is shown
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isEmpty) {
      try {
        await Provider.of<ProductData>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occured!'),
            content: const Text('Something unexpected happened'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    } else {
      await Provider.of<ProductData>(context, listen: false)
          .updateProduct(_editedProduct);
      Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      onSaved: (v) {
                        _editedProduct = _editedProduct.copyWith(
                          title: v,
                        );
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue:
                          '${_editedProduct.price > 0 ? _editedProduct.price : ''}',
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (v) {
                        _editedProduct = _editedProduct.copyWith(
                          price: double.parse(v!),
                        );
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please provide a value.';
                        }
                        if (double.tryParse(v) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(v) < 0) {
                          return 'Please enter a positive number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (v) {
                        _editedProduct = _editedProduct.copyWith(
                          description: v,
                        );
                      },
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (v.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          //preview
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text('Enter a URL'),
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // TextField with controller cannot have an initialValueField
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            // use a controller to add a preview of the image
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onEditingComplete: () {
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (v) {
                              _editedProduct = _editedProduct.copyWith(
                                imageUrl: v,
                              );
                            },
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please provide a value';
                              }
                              if (!v.startsWith('http://') &&
                                  !v.startsWith('https://')) {
                                return 'Please enter a valid URL.';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
