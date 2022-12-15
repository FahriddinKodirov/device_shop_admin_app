import 'package:admin_app/data/models/product_model.dart';
import 'package:admin_app/screen/admin_page/products/add_product_screen.dart';
import 'package:admin_app/screen/admin_page/products/update_product_screen.dart';
import 'package:admin_app/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Products Admin"),
            actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body:  Consumer<ProductViewModel>(
        builder: (context, productViewModel, child) {
          return ListView(
            children: List.generate(productViewModel.products.length, (index) {
              var product = productViewModel.products[index];
              return ListTile(
                title: Text(product.product_name),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductScreen(
                                  productModel: product,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            context
                                .read<ProductViewModel>()
                                .deleteProduct(product.product_id);
                            print("DELETING ID:${product.product_id}");
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );

  }
}

