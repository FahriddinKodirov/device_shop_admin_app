import 'package:admin_app/data/models/category_model.dart';
import 'package:admin_app/data/models/product_model.dart';
import 'package:admin_app/utils/my_utils.dart';
import 'package:admin_app/view_models/categories_view_model.dart';
import 'package:admin_app/view_models/products_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
   
   final TextEditingController countController = TextEditingController();
   final TextEditingController priceController = TextEditingController();
   final TextEditingController nameController = TextEditingController();
   final TextEditingController descriptionController = TextEditingController();
   List<String> productImages = [
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
    "https://www.pngitem.com/pimgs/m/183-1831803_laptop-collection-png-transparent-png.png",
  ];
   String category_id = '';
   CategoryModel? categoryModel;
   String created_at = DateTime.now().toString();
   List<String> currencies = ["USD", "SO'M", "RUBL", "TENGE"];
   String selectedCurrency = "USD";


   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  AppBar(
        title: const Text('Add Product screen'),
       ),
      body: Padding(padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(children: [
           TextField( 
            controller: countController,
            keyboardType: TextInputType.number,
            decoration: getInputDecoration(label: "Count")),
            SizedBox(height: 20),
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
                    category_id = categoryModel!.category_id;
                    setState(() {});
                  });
                },
                child: Text(
                  categoryModel == null
                      ? "Select Category"
                      : categoryModel!.category_name,
                ),
              ),
              TextButton(onPressed: (){
                ProductModel productModel = ProductModel(
                  count: int.parse(countController.text),
                  price: int.parse(priceController.text),
                  product_images: productImages,
                  category_id: category_id,
                  product_id: '',
                  product_name: nameController.text,
                  description: descriptionController.text,
                  created_at: created_at,
                  currency: selectedCurrency
                 );
                 Provider.of<ProductViewModel>(context,listen: false).addProduct(productModel);
              }, child: Text("Add Product to Fire Store"))
               
           
          ],)),),
    );
  }
 selectCategory(ValueChanged<CategoryModel> onCategorySelect){
  showDialog(
    context: context, 
    builder: (context){
      return Dialog(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.infinity,
          child: StreamBuilder<List<CategoryModel>>(
            stream:Provider.of<CategoriesViewModel>(context, listen: false).
              listenCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                if(snapshot.hasData){
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
                      )),
                  );
                } else {
                  return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  
                }

              }, ),
        ),
      );
    });
 }

}
