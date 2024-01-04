import 'package:flutter/material.dart';
import 'package:flutter_dashboard/const.dart';
import 'package:flutter_dashboard/responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.scaffoldKey,
    required this.onForumPressed,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function()? onForumPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () => scaffoldKey.currentState!.openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              ),
            ),
          if (!Responsive.isMobile(context))
            Expanded(
              flex: 4,
              child: TextField(
                decoration: InputDecoration(
                  // ... (votre décoration de recherche)
                ),
              ),
            ),
          if (Responsive.isMobile(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onPressed: () {
                    // Logique de recherche
                  },
                ),
                InkWell(
                  onTap: onForumPressed,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      "assets/images/avatar.png", // Assurez-vous d'avoir le bon chemin d'accès à l'image
                      width: 32,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
