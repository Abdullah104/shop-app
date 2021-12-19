import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import 'products_overview_route.dart';

enum RoutePurpose { addNewProduct, editExistingProduct }

class EditProductRoute extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductRoute({Key? key}) : super(key: key);

  @override
  State<EditProductRoute> createState() => _EditProductRouteState();
}

class _EditProductRouteState extends State<EditProductRoute> {
  final _controller = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late Product product;
  late final Map<String, dynamic> arguments;
  var _isInit = true;
  late final Map<String, dynamic> _initValues;
  late final RoutePurpose purpose;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      product = arguments['product'] as Product? ??
          Product(
            id: DateTime.now().toString(),
            title: '',
            description: '',
            price: 0,
            imageUrl: '',
            isFavorite: false,
          );

      _initValues = {
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'image_url': product.imageUrl,
      };

      _controller.text = _initValues['image_url'];

      purpose = arguments['purpose'];

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${purpose == RoutePurpose.addNewProduct ? "Add New" : "Edit"} Product',
        ),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (title) => product = Product(
                          id: product.id,
                          title: title!,
                          description: product.description,
                          price: product.price,
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                        ),
                        validator: (title) {
                          String? errorMessage;

                          if (title == null) {
                            errorMessage = 'Please provide a value';
                          } else {
                            if (title.isEmpty) {
                              errorMessage = 'Please provide a value';
                            }
                          }

                          return errorMessage;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'].toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (price) => product = Product(
                          id: product.id,
                          title: product.title,
                          description: product.description,
                          price: double.parse(price!),
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                        ),
                        validator: (price) {
                          String? errorMessage;

                          if (price == null) {
                            errorMessage = 'Please provide a value';
                          } else {
                            if (price.isEmpty) {
                              errorMessage = 'Please provide a value';
                            }
                            final value = double.tryParse(price);

                            if (value == null) {
                              errorMessage = 'Price not correct';
                            } else if (value < 0) {
                              errorMessage = 'Price not correct';
                            }
                          }

                          return errorMessage;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        onSaved: (description) => product = Product(
                          id: product.id,
                          title: product.title,
                          description: description!,
                          price: product.price,
                          imageUrl: product.imageUrl,
                          isFavorite: product.isFavorite,
                        ),
                        validator: (description) {
                          String? errorMessage;

                          if (description == null) {
                            errorMessage = 'Please provide a value';
                          } else {
                            if (description.isEmpty) {
                              errorMessage = 'Please provide a value';
                            }
                          }

                          return errorMessage;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            child: _controller.text.isEmpty
                                ? const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text('Enter a URL'),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _controller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _controller,
                              // initialValue: _initValues['image_url'],
                              focusNode: _imageUrlFocusNode,
                              decoration: const InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _saveForm,
                              onSaved: (imageUrl) => product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: product.price,
                                imageUrl: imageUrl!,
                                isFavorite: product.isFavorite,
                              ),
                              validator: (imageUrl) {
                                String? errorMessage;

                                if (imageUrl == null) {
                                  errorMessage = 'Please provide a value';
                                } else {
                                  if (imageUrl.isEmpty) {
                                    errorMessage = 'Please provide a value';
                                  }
                                }

                                return errorMessage;
                              },
                              onEditingComplete: () => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  void _updateImage() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final products = context.read<Products>();
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      if (purpose == RoutePurpose.addNewProduct) {
        try {
          await products.addProduct(product);
        } catch (_) {
          // ignore: prefer_void_to_null
          await showDialog<Null>(
            context: context,
            builder: (error) => AlertDialog(
              title: const Text('Something went wrong'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        }
      } else {
        await products.updateProduct(product.id, product);
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        ProductsOverview.routeName,
        (route) => false,
      );
    }
  }
}
