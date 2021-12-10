import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';

class ProductDetailsRoute extends StatefulWidget {
  static const routeName = '/product-details';

  const ProductDetailsRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailsRoute> createState() => _ProductDetailsRouteState();
}

class _ProductDetailsRouteState extends State<ProductDetailsRoute> {
  var heights = <double>[300, 600];
  var index = 0;

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => index = (index + 1) % heights.length),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 400),
                child: SizedBox(
                  height: heights[index],
                  width: double.infinity,
                  child: Hero(
                    tag: product.id,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '${product.price} SAR',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
