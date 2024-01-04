import 'package:flutter/material.dart';
import 'package:flutter_dashboard/services/network_service.dart' as networkService;
import 'package:flutter_dashboard/screens/product_add.dart';
import 'package:flutter_dashboard/screens/product_edit.dart'; // Import the screen for editing products

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      List<dynamic> productList = await networkService.ProductService.fetchProducts();
      setState(() {
        products = productList;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await networkService.ProductService.deleteProduct(productId);
      fetchProducts(); // Refresh product list after deletion
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  Future<void> updateProduct(dynamic product) async {
    // Navigate to the edit screen and pass the product details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditScreen(product: product),
      ),
    ).then((_) => fetchProducts()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              title: Text(products[index]['name']),
              subtitle: Text('Prix: \$${products[index]['prix']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      updateProduct(products[index]); // Pass the selected product for editing
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteProduct(products[index]['_id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          ).then((_) => fetchProducts()); // Refresh list after adding a product
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
