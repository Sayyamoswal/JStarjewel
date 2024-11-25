import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/BuyPage.dart';
import 'package:flutter_application_1/Screens/Search_scrren.dart';
import 'package:flutter_application_1/Screens/category_screen.dart';
import 'package:flutter_application_1/Screens/favorites_manager.dart';
import 'package:flutter_application_1/Screens/favourite_scrren.dart';
import 'package:flutter_application_1/Screens/ProductCard.dart';
import 'package:flutter_application_1/model/order_model.dart';
import 'package:flutter_application_1/databas/order_database_helper.dart';
import 'package:flutter_application_1/Screens/MyorderScreen.dart';


class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> orderDetails; // Order details for My Order navigation

  HomeScreen({this.orderDetails = const {}});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDD0), // Cream background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Jewellery',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red), // Heart icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icons Horizontal Scroll
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryIcon('Earrings', 'assets/Bangles/Image4.jpg'),
                  _buildCategoryIcon('Necklace', 'assets/Bangles/Image4.jpg'),
                  _buildCategoryIcon('Chains', 'assets/Bangles/Image4.jpg'),
                  _buildCategoryIcon('Rings', 'assets/Rings/Image1.jpg'),
                  _buildCategoryIcon('Bangles', 'assets/Bangles/Image4.jpg'),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Top Choice Section Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Top Choice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Top Choice Items Vertical Scroll
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
              itemCount: 8, // Set the count of items you want to show
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7, // Adjust for image size
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  imagePath: 'assets/Bangles/Bangles1.jpg',
                  title: "Top Choice",
                  totalWeight: 5.0,
                  stoneWeight: 0.5,
                  goldRate: 8000.0,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Order',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to Home (reload HomeScreen here)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(orderDetails: orderDetails)),
            );
          } else if (index == 1) {
            // Navigate to Categories
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryScreen()),
            );
          } else if (index == 2) {
            /// Check if there are any orders in SQLite
    OrderDatabaseHelper().getAllOrders().then((orders) {
      if (orders.isNotEmpty) {
        // Navigate to My Orders Screen if there are orders
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersScreen()),
        );
      } else {
              // Show message if no orders are available
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("No orders placed yet."),
                ),
              );
            }
          });
        }
      }
      ),
    );
  }

  // Category Icon widget
  Widget _buildCategoryIcon(String label, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }
}
