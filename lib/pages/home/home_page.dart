import 'package:flutter/material.dart';
import 'package:flutter_dashboard/pages/home/widgets/header_widget.dart';
import 'package:flutter_dashboard/pages/forum/forum_list.dart'; 
import 'package:flutter_dashboard/responsive.dart';
import 'package:flutter_dashboard/pages/home/widgets/activity_details_card.dart';
import 'package:flutter_dashboard/pages/home/widgets/bar_graph_card.dart';
import 'package:flutter_dashboard/pages/home/widgets/line_chart_card.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomePage({super.key, required this.scaffoldKey});

  // Fonction pour naviguer vers la liste des forums
  void navigateToForumList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForumList()),
    );
  }

  SizedBox _height(BuildContext context) => SizedBox(
        height: Responsive.isDesktop(context) ? 30 : 20,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 15 : 18,
          ),
          child: Column(
            children: [
              SizedBox(
                height: Responsive.isMobile(context) ? 5 : 18,
              ),
              Header(
                scaffoldKey: scaffoldKey,
                onForumPressed: () => navigateToForumList(context),
              ),
              _height(context),
              const ActivityDetailsCard(),
              _height(context),
              LineChartCard(),
              _height(context),
              BarGraphCard(),
              _height(context),
            ],
          ),
        ),
      ),
    );
  }
}
