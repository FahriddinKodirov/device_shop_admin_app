import 'package:admin_app/data/models/category_model.dart';
import 'package:admin_app/view_models/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateCategoryScreen extends StatefulWidget {
  const UpdateCategoryScreen({Key? key, required this.categoryModel})
      : super(key: key);

  final CategoryModel categoryModel;

  @override
  State<UpdateCategoryScreen> createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Update Category"),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              CategoryModel categoryModel = CategoryModel(
                category_id: widget.categoryModel.category_id,
                category_name: "Muzlat",
                description: widget.categoryModel.description,
                image_url: widget.categoryModel.image_url,
                created_at: widget.categoryModel.created_at,
              );
              Provider.of<CategoriesViewModel>(context, listen: false)
                  .updateCategory(categoryModel);
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
    );
  }
}