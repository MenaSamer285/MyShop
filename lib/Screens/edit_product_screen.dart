import 'package:MyShop/Providers/product.dart';
import 'package:MyShop/Providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = "edit_product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _loaded = false;
  var _edittedProduct = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    isFavourite: false,
    price: 0.0,
  );
  var _initValues = {
    "id": "",
    "title": "",
    "description": "",
    "price": " 0.0",
  };

  @override
  void didChangeDependencies() {
    var productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      _edittedProduct =
          Provider.of<Products>(context, listen: false).findById(productId);
      _initValues = {
        "id": _edittedProduct.id,
        "title": _edittedProduct.title,
        "description": _edittedProduct.description,
        "price": _edittedProduct.price.toString(),
      };
      _imageUrlController.text = _edittedProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlController.text = "";
    _imageUrlController.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if ((!_imageUrlController.text.startsWith("http") &&
            !_imageUrlController.text.startsWith("https")) ||
        (!_imageUrlController.text.endsWith(".png") &&
            !_imageUrlController.text.endsWith(".jpg") &&
            !_imageUrlController.text.endsWith(".jpeg"))) return;
    setState(() {});
  }

  void _saveForm() async {
    setState(() {
      _loaded = true;
    });
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_edittedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_edittedProduct);
        Navigator.of(context).pop();
      } catch (error) {
        showDialog(
          barrierDismissible: false,
          context: context,
          child: AlertDialog(
            title: new Text("Error"),
            content: Text("there is error"),
            actions: [
              FlatButton(
                onPressed: () {
                  setState(() {
                    _loaded = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Text("ok"),
              )
            ],
          ),
        );
      }
    } else {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_edittedProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _edittedProduct.id == null
            ? Text("Add Product")
            : Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _loaded ? null : _saveForm,
          ),
        ],
      ),
      body: Stack(children: [
        if (_loaded)
          Container(
            color: Colors.black26,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  enabled: _loaded ? false : true,
                  initialValue: _initValues["title"],
                  decoration: InputDecoration(labelText: "title"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) return "please provide title";
                    return null;
                  },
                  onSaved: (newValue) {
                    _edittedProduct = Product(
                      id: _edittedProduct.id,
                      title: newValue,
                      description: _edittedProduct.description,
                      imageUrl: _edittedProduct.imageUrl,
                      price: _edittedProduct.price,
                      isFavourite: _edittedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  enabled: _loaded ? false : true,
                  initialValue: _initValues["price"],
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty) return "please provide title";
                    if (double.tryParse(value) == null ||
                        double.parse(value) < 0)
                      return "Please enter valid number";
                    return null;
                  },
                  onSaved: (newValue) {
                    _edittedProduct = Product(
                      id: _edittedProduct.id,
                      title: _edittedProduct.title,
                      description: _edittedProduct.description,
                      imageUrl: _edittedProduct.imageUrl,
                      price: double.parse(newValue),
                      isFavourite: _edittedProduct.isFavourite,
                    );
                  },
                ),
                TextFormField(
                  enabled: _loaded ? false : true,
                  initialValue: _initValues["description"],
                  decoration: InputDecoration(labelText: "Description"),
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value.isEmpty) return "please enter description";
                    if (value.length < 10)
                      return "Please enter at least 10 character";
                    return null;
                  },
                  onSaved: (newValue) {
                    _edittedProduct = Product(
                      id: _edittedProduct.id,
                      title: _edittedProduct.title,
                      description: newValue,
                      imageUrl: _edittedProduct.imageUrl,
                      price: _edittedProduct.price,
                      isFavourite: _edittedProduct.isFavourite,
                    );
                  },
                ),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter url")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        enabled: _loaded ? false : true,
                        decoration: InputDecoration(labelText: 'Image url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (value) => _saveForm(),
                        validator: (value) {
                          if (value.isEmpty) return "please provide title";
                          if (!value.startsWith("http") &&
                              !value.startsWith("https"))
                            return "Please enter valid url";
                          if (!value.endsWith(".png") &&
                              !value.endsWith(".jpg") &&
                              !value.endsWith(".jpeg"))
                            return "Please enter valid image url";
                          return null;
                        },
                        onSaved: (newValue) {
                          _edittedProduct = Product(
                            id: _edittedProduct.id,
                            title: _edittedProduct.title,
                            description: _edittedProduct.description,
                            imageUrl: newValue,
                            price: _edittedProduct.price,
                            isFavourite: _edittedProduct.isFavourite,
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
      ]),
    );
  }
}
