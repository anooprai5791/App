import 'package:flutter/material.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upcomingOrders = [];
    final List<Map<String, dynamic>> pastOrders = [
      {'service': 'AC Service', 'date': 'Apr 5'},
      {'service': 'Washing Machine Repair', 'date': 'Mar 28'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Semantics(
                header: true,
                child: Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

               Semantics(
                header: true,
                child: Text(
                  'Upcoming',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),

              upcomingOrders.isEmpty
                  ? Semantics(
                      label: 'No upcoming work',
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: const Center(
                          child: Text(
                            'You have no upcoming work',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingOrders.length,
                      itemBuilder: (context, index) {
                        final order = upcomingOrders[index];
                        return GestureDetector(
                          onTap: () => CustomNavigator.pushTo(
                              context, AppPages.ordersdetailspage),
                          child: buildOrderCard(
                              order['service'], order['date'],
                              showRebook: false),
                        );
                      },
                    ),

              const SizedBox(height: 30),

               Semantics(
                header: true,
                child: Text(
                  'Past',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pastOrders.length,
                itemBuilder: (context, index) {
                  final order = pastOrders[index];
                  return GestureDetector(
                    onTap: () => CustomNavigator.pushTo(
                        context, AppPages.ordersdetailspage),
                    child: buildOrderCard(order['service'], order['date'],
                        showRebook: true),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderCard(String service, String date, {bool showRebook = false}) {
    return Semantics(
      label: '$service on $date',
      button: true,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.build_circle_outlined,
                size: 30, color: Colors.deepPurple),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(date, style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            if (showRebook)
              Semantics(
                label: 'Rebook $service',
                button: true,
                child: ElevatedButton(
                  onPressed: () {
                    // Add rebook logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D3FD3),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Rebook', style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
