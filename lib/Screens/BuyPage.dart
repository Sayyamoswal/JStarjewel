import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_application_1/Screens/OrderPlacedScrren.dart';
import 'package:flutter_application_1/model/order_model.dart';
import 'package:flutter_application_1/databas/order_database_helper.dart';

class BuyPage extends StatelessWidget {
  final String contactInfo;
  final String phoneNumber;
  final String address;
  final double itemPrice;
  final double makingCharges;
  final double tax;
  final double totalAmount;
  final String imagePath;
  final String category;
  final List<Map<String, dynamic>> products;
  final VoidCallback onOrderPlaced; // Callback to notify MyOrdersScreen

  BuyPage({
    required this.contactInfo,
    required this.phoneNumber,
    required this.address,
    required this.itemPrice,
    required this.makingCharges,
    required this.tax,
    required this.totalAmount,
    required this.imagePath,
    required this.category,
    required this.products,
    required this.onOrderPlaced, // Accept the callback
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
        backgroundColor: Color(0xFFFFFDD0),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFFFFDD0),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...products.map((product){
             return Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contact: $contactInfo", style: TextStyle(fontSize: 14)),
                      Text("Phone: $phoneNumber", style: TextStyle(fontSize: 14)),
                      Text("Address: $address", style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            );
            }).toList(),
            Spacer(),
            SizedBox(height: 16),
            Divider(color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Price Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildPriceRow("Item Price", "₹${itemPrice.toStringAsFixed(2)}"),
            _buildPriceRow("Making Charges", "₹${makingCharges.toStringAsFixed(2)}"),
            _buildPriceRow("Tax", "₹${tax.toStringAsFixed(2)}"),
            Divider(color: Colors.grey),
            _buildPriceRow(
              "Total Amount",
              "₹${totalAmount.toStringAsFixed(2)}",
              isBold: true,
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Save order details to SQLite
                  final order = Order(
                    id: 0, // SQLite will auto-increment this
                    imagePath: imagePath,
                    title: "Product Title", // Replace with actual product title if available
                    price: totalAmount,
                    category: category, // Specify the category dynamically
                    orderTime: DateTime.now(),
                  );

                  final dbHelper = OrderDatabaseHelper();
                  await dbHelper.insertOrder(order);
                  print("Order placed successfully: ${order.toMap()}");

                  // Notify MyOrdersScreen to reload orders
                  onOrderPlaced();

                  // Navigate to OrderPlacedScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPlacedScreen(
                        contactInfo: contactInfo,
                        phoneNumber: phoneNumber,
                        address: address,
                        itemPrice: itemPrice,
                        makingCharges: makingCharges,
                        tax: tax,
                        totalAmount: totalAmount,
                        imagePath: imagePath,
                        onOrderPlaced: () {
                          
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Place Your Order",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


  