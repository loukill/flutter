import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/home/home_page_category.dart';
import 'package:flutter_dashboard/widgets/category/menu_category.dart';
import 'package:flutter_dashboard/responsive.dart';

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
            // Affiche le menu latéral uniquement en mode bureau
            if (Responsive.isDesktop(context))
              Expanded(
                // Moins de flexibilité pour réduire la taille du menu
                flex: 2,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MenuCat(scaffoldKey: _scaffoldKey),
                ),
              ),
            // Contenu principal qui prendra tout l'espace restant
            Expanded(
              // Plus de flexibilité pour augmenter la taille du tableau
              flex: Responsive.isDesktop(context) ? 6 : 1,
              child: HomePageCat(),
            ),
          ],
        ),
      ),
    );
  }
}
