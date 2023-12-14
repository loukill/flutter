import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/home/home_page_category.dart';
import 'package:flutter_dashboard/widgets/category/menu_category.dart';
import 'package:flutter_dashboard/Responsive.dart';

class CategoryDashboard extends StatelessWidget {
  CategoryDashboard({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !Responsive.isDesktop(context) 
          ? SizedBox(width: 250, child: MenuCat(scaffoldKey: _scaffoldKey)) 
          : null,
      body: SafeArea(
        child: Row(
          children: [
            // Menu latéral pour les écrans de bureau
            if (Responsive.isDesktop(context))
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MenuCat(scaffoldKey: _scaffoldKey),
                ),
              ),
            // Contenu principal
            Expanded(
              flex: 8,
              child: HomePageCat(), // Retiré le scaffoldKey de HomePage
            ),
          ],
        ),
      ),
    );
  }
}
