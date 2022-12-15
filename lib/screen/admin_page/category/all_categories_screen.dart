import 'package:admin_app/data/models/category_model.dart';
import 'package:admin_app/screen/admin_page/category/add_category_screen.dart';
import 'package:admin_app/screen/admin_page/category/update_category_screen.dart';
import 'package:admin_app/view_models/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories Admin"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCategoryScreen()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<List<CategoryModel>>(
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
              children: List.generate(categories.length, (index) {
                CategoryModel category = categories[index];
                return ListTile(
                  title: Text(category.category_name),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateCategoryScreen(
                                    categoryModel: category,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              Provider.of<CategoriesViewModel>(context,
                                      listen: false)
                                  .deleteCategory(category.category_id);
                              print("DELETING ID:${category.category_id}");
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              }),
            );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        },
      ),
    );
  }
}
