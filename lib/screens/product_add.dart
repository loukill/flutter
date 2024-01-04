import 'package:flutter/material.dart';
import 'package:flutter_dashboard/services/network_service.dart' ;

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: prixController,
              decoration: InputDecoration(labelText: 'Prix'),
              keyboardType: TextInputType.number, // Ensures numeric keyboard
            ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number, // Ensures numeric keyboard
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            ElevatedButton(
              onPressed: () {
                String productName = nameController.text;
                if (productName.length >= 5) {
                  Map<String, dynamic> productData = {
                    'name': productName,
                    'description': descriptionController.text,
                    'prix': double.parse(prixController.text),
                    'quantity': int.parse(quantityController.text),
                    'category': categoryController.text,
                  };

                  ProductService.addProduct(productData)
                      .then((_) {
                        // Refresh product list after successful addition
                        ProductService.fetchProducts(); // Call your function to refresh the product list
                        Navigator.pop(context); // Close the Add Product screen
                      })
                      .catchError((error) {
                        // Handle error - log or display error message
                        print('Error adding product: $error');
                      });
                } else {
                  // Handle error or show a message indicating that the name is too short
                  print('Product name should be at least 5 characters long.');
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
