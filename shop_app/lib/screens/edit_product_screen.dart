import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

// 219-220) to be filled up, it will manage the products related input.
class _EditProductScreenState extends State<EditProductScreen> {
  // 221-223) focusNode helps us with navigation through our fields, it needs to be instantiated .
  final _priceFocusNode = FocusNode();
// 224) addition of focusNode for description field
  final _descriptionFocusNode = FocusNode();

// 225) controller will be created, so we can listen to the changes and act upon them
// kind of like formControll in angular.
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

// 227-229)  addition of globalKey which is bound to the form
// also initial value of product.
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

// 232-233) init value is added, so it can be passed to the controller.
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  // // 225)this will cause refresh on the image widget
  // 227-229)  validation
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

// 227-229)  some func, which is called on submit on top as button or after the final field is written.
  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    // this triggers onSaveSubmit on each form_field, and within each field they fill up the  props.
    _form.currentState.save();
    // 230) here the products(provider) does the job of saving our state (in-memory).
    // 232-233) => the edit logic is added as well, depending if we have id or not.
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

// [imp/] the nodes are futures and you must dispose of them
// that is why we use the widget onDestroy cycle to get rid of them.
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();

// 225) it needs to be disposed too! (both controller and focusNode)
    _imageUrlController.dispose();
    // 225) also the listener must be removed as well (as a funcreference)
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // 225) with this we`ll force the input , on switch of the input field!
    // reference is passed here ..
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  // 232- 233) and this is used as well , because in initState it would be overwritten.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      // 232-233)  args are taken from route as this is a screen!
      final productId = ModalRoute.of(context).settings.arguments as String;
      // 232-233) here in case there is an injected product (edit_regime) it will rewrite it, because we know it will be passed from another route.
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            // 227-229) the func is inserted here.
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 221-223) intro to Form (later it will be shown how to extract info from it.)
        child: Form(
          //227-229) => the id needs tobe linked, otherwise they would not work!
          key: _form,
          // 221-223) its a bad idea to use listView , because in smaller windows/screens it will cut off your input fields
          // because of the "smart algorithms"
          child: ListView(
            children: <Widget>[
              // 221-223) one simple type of field
              TextFormField(
                //232-233) addition of initValue , which is added from initState , in case its empty!
                initialValue: _initValues['title'],

                // 221-223) with decoration you can "style" your input with different ways ( check docs.)
                decoration: InputDecoration(labelText: 'Title'),

                // 221-223) here is a combination of how to transfer the focus on to the next field.
                textInputAction: TextInputAction.next,
                // [imp/] 221-223) logic is that focusScope is pointing towards priceFocusNode , and its attached to the second node
                // at least so I understood.
                //  next removes the focus i think (and with focusNode the focus is transfered to some pointed node!)
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                // 227-229) validation is just some func,called within each field.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null;
                },
                // 227-229) method called in different cases (for example within form.save)
                onSaved: (value) {
                  // the value of the previous products are  preserved along side the new value of each field!
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,

                    // 232-233) addition of product on save (in case there is one)
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                // 232-233) => again initValue
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                // 221-223) its again important to set the type of keyborad,
                // so that the user doesn`t have to do it himself

                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  // 224) here the input will be redirected to the text description field.
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // 227-229) more validation
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      // 232-233) preserving the state from edit!
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),

              // 224) different input field for longer text.
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                // 224) also different keyboard type
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),

              // 225) you can add any type of widgets, not only formFields
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    // 225) for styling , you keep forgetting this!
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),

                    // 225) here the controller is used so it is know, whther an image is loadeded or not
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  // 225) wrappedin expanded , because otherwise it would occupy all of the space and would cause a problem.
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // 225)  here, the controller from above is attached!
                      controller: _imageUrlController,
                      // 225) also a node is attached here, so the input can be forced, upon focus out.
                      focusNode: _imageUrlFocusNode,
                      // 227-229) finally  here the submit is called , like the one in the button on top!
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
