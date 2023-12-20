import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/category/widgets/category_add_dialog.dart';
import 'package:flutter_dashboard/pages/category/widgets/custon_data_table.dart';
import 'package:flutter_dashboard/responsive.dart';

class HomePageCat extends StatefulWidget {
  const HomePageCat({super.key});

  @override
  _HomePageCatState createState() => _HomePageCatState();
}

class _HomePageCatState extends State<HomePageCat> {
  List<Map<String, dynamic>> categories = [];

  // Cette méthode sera appelée lorsque une nouvelle catégorie est ajoutée avec succès.
  // Elle doit ajouter la nouvelle catégorie à la liste des catégories et rafraîchir l'interface utilisateur.
  void _onCategoryAdded(Map<String, dynamic> newCategory) {
    setState(() {
      categories.add(newCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 10 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
            children: [
              SizedBox(height: Responsive.isMobile(context) ? 5 : 18),
              Text(
                "Category Management", 
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 30 : 20),
              Card(
                elevation: 4,
                margin: EdgeInsets.all(8), // Adds shadow
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDataTable( 
                    categories: categories,
        onCategoryAdded: _onCategoryAdded,),
                ),
              ),
              SizedBox(height: Responsive.isDesktop(context) ? 30 : 20),
              // Ajoutez d'autres widgets si nécessaire
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
      context: context,
      builder: (context) => CategoryAddDialog( onCategoryAdded: _onCategoryAdded,),
    );
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter une catégorie',
      ),
    );
  }
}