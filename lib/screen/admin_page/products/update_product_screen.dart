import 'package:admin_app/data/models/category_model.dart';
import 'package:admin_app/data/models/product_model.dart';
import 'package:admin_app/utils/my_utils.dart';
import 'package:admin_app/view_models/categories_view_model.dart';
import 'package:admin_app/view_models/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({Key? key, required this.productModel})
      : super(key: key);

  final ProductModel productModel;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController countController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> productImages = [
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
  ];
  String categoryId = "";
  CategoryModel? categoryModel;
  List<String> currencies = ["USD", "SO'M", "RUBL", "TENGE"];
  String selectedCurrency = "USD";

  @override
  void initState() {
    countController.text = widget.productModel.count.toString();
    priceController.text = widget.productModel.price.toString();
    nameController.text = widget.productModel.product_name;
    descriptionController.text = widget.productModel.description;
    categoryId = widget.productModel.category_id;
    selectedCurrency = widget.productModel.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product screen"),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: countController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Count"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: getInputDecoration(label: "Price"),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: getInputDecoration(label: "Product Name"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: TextField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 20,
                  decoration: getInputDecoration(label: "Description"),
                ),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                title: Text(selectedCurrency.isEmpty
                    ? "Select  Currncy"
                    : selectedCurrency),
                children: [
                  ...List.generate(
                      currencies.length,
                          (index) => ListTile(
                        title: Text(currencies[index]),
                        onTap: () {
                          setState(() {
                            selectedCurrency = currencies[index];
                          });
                        },
                      ))
                ],
              ),
              TextButton(
                onPressed: () {
                  selectCategory((selectedCategory) {
                    categoryModel = selectedCategory;
                    categoryId = categoryModel!.category_id;
                    setState(() {});
                  });
                },
                child: Text(
                  categoryModel == null
                      ? "Select Category"
                      : categoryModel!.category_name,
                ),
              ),

              TextButton(
                onPressed: () {
                  ProductModel productModel = ProductModel(
                    count: int.parse(countController.text),
                    price: int.parse(priceController.text),
                    product_images: productImages,
                    category_id: categoryId,
                    product_id: widget.productModel.product_id,
                    product_name: nameController.text,
                    description: descriptionController.text,
                    created_at: widget.productModel.created_at,
                    currency: selectedCurrency,
                  );

                  Provider.of<ProductViewModel>(context,listen: false).updateProduct(productModel);

                },
                child: Text("Update Product to Fire Store"),
              )
            ],
          ),
        ),
      )
    );
  }
  selectCategory(ValueChanged<CategoryModel> onCategorySelect) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: double.infinity,
              child: StreamBuilder<List<CategoryModel>>(
                stream: Provider.of<CategoriesViewModel>(context, listen: false)
                    .listenCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    List<CategoryModel> categories = snapshot.data!;
                    return ListView(
                      children: List.generate(
                        categories.length,
                            (index) => ListTile(
                          title: Text(categories[index].category_name),
                          onTap: () {
                            onCategorySelect.call(categories[index]);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                },
              ),
            ),
          );
        });
  }
}