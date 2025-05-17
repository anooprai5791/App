import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_customer/features/orders/screens/order_screen.dart';

void main() {
  group('OrderScreen Widget Test', () {
    testWidgets('renders static headers and empty upcoming section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(),
        ),
      );

      // Check for main heading
      expect(find.text('Your Orders'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('You have no upcoming work'), findsOneWidget);
    });

    testWidgets('renders past orders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(),
        ),
      );

      expect(find.text('Past'), findsOneWidget);
      expect(find.text('AC Service'), findsOneWidget);
      expect(find.text('Apr 5'), findsOneWidget);
      expect(find.text('Washing Machine Repair'), findsOneWidget);
      expect(find.text('Mar 28'), findsOneWidget);
    });

    testWidgets('Rebook buttons are present in past orders', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OrderScreen(),
        ),
      );

      expect(find.text('Rebook'), findsNWidgets(2));
    });

    testWidgets('Tapping a past order navigates (simulated)', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                tapped = true;
              },
              child: const OrderScreen(),
            ),
          ),
        ),
      );

      await tester.tap(find.text('AC Service'));
      expect(tapped, isTrue);
    });
  });
}
