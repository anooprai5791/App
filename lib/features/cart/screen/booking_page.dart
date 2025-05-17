import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/features/cart/data/booking_provider.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: Semantics(
            label: 'Go back',
            button: true,
            child: const BackButton(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Booking Page',
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Name & Mobile
                  Semantics(
                    label: 'User details',
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(provider.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                Text(provider.mobile, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _editDetails(context, provider),
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Address
                  Semantics(
                    label: 'Address field. Tap to edit.',
                    child: GestureDetector(
                      onTap: () => _editAddress(context, provider),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: 500.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(provider.address.isEmpty ? 'Select Address' : provider.address),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text('Select Slot', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Preferred Date'),
                  const SizedBox(height: 8),

                  // Date Options
                  Row(
                    children: provider.availableDates
                        .map((date) => _buildDateBox(context, date, provider))
                        .toList(),
                  ),

                  if (provider.selectedDate != null) ...[
                    const SizedBox(height: 24),
                    const Text('Preferred Time'),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.3,
                      children: provider
                          .getAvailableTimes()
                          .map((time) => _buildTimeBox(context, time, provider))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Booking Button
                  Semantics(
                    label: 'Book service',
                    button: true,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: provider.canBook()
                            ? () => CustomNavigator.pushTo(context, AppPages.providerFindingpage)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        ),
                        child: const Text('Book', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Price List will be available once provider is assigned',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateBox(BuildContext context, DateTime date, BookingProvider provider) {
    final formatted = DateFormat('d MMM').format(date);
    final isSelected = provider.selectedDate == date;

    return Semantics(
      label: isSelected ? 'Selected date $formatted' : 'Tap to select date $formatted',
      button: true,
      child: GestureDetector(
        onTap: () => provider.toggleSelectedDate(date),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            formatted.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(BuildContext context, TimeOfDay time, BookingProvider provider) {
    final isSelected = provider.selectedTime == time;

    return Semantics(
      label: isSelected
          ? 'Selected time ${time.format(context)}'
          : 'Tap to select ${time.format(context)}',
      button: true,
      child: GestureDetector(
        onTap: () => provider.toggleSelectedTime(time),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time.format(context),
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _editDetails(BuildContext context, BookingProvider provider) {
    final nameCtrl = TextEditingController(text: provider.name);
    final mobileCtrl = TextEditingController(text: provider.mobile);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 10),
            TextField(
              controller: mobileCtrl,
              decoration: const InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateName(nameCtrl.text);
              provider.updateMobile(mobileCtrl.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editAddress(BuildContext context, BookingProvider provider) {
    final ctrl = TextEditingController(text: provider.address);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Address'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Address')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.updateAddress(ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
