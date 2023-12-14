import 'dart:js';

import 'package:Dyslire/page/ajoutpage.dart';
import 'package:flutter/material.dart';
import 'package:Dyslire/model/fourniture.dart';
import 'package:Dyslire/page/detail_pagepro.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int indexCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green[200],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          header(),
          const SizedBox(height: 30),
          title(),
          const SizedBox(height: 20),
          search(),
          const SizedBox(height: 30),
          categories(),
          const SizedBox(height: 20),
          listItems(),
          addFournitureButton(), // Add this line to include the button
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Material(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                child: const Icon(Icons.menu, color: Colors.black),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.location_on, color: Colors.white, size: 18),
          const Text('Tunisie'),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'asset/Capture.PNG',
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dyslire',
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Text(
            'CHERCHER VOTRE FOURNITURE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
          ),
        ],
      ),
    );
  }

  Widget search() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(8, 2, 6, 2),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.purple),
                hintText: 'Chercher Fourniture',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
          Material(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                child: const Icon(Icons.bar_chart, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categories() {
    List<String> list = ['Logiciel', 'Materiels'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              indexCategory = index;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(
                index == 0 ? 16 : 16,
                0,
                index == list.length - 1 ? 16 : 16,
                0,
              ),
              alignment: Alignment.center,
              child: Text(
                list[index],
                style: TextStyle(
                  fontSize: 22,
                  color: indexCategory == index ? Colors.purple : Colors.grey,
                  fontWeight: indexCategory == index ? FontWeight.bold : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ...

  Widget listItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyfourniture.length,
      itemBuilder: (context, index) {
        fourniture food = dummyfourniture[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailPage(food: food);
            }));
          },
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          food.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              food.disponibility,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              food.rate.toString(),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '\$${food.price}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Handle the edit functionality here
                    print('Edit pressed for ${food.name}');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Handle the delete functionality here
                    setState(() {
                      dummyfourniture.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget addFournitureButton() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => AjoutPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Ajouter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
