import 'package:flutter/material.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';

class ProviderFindingPage extends StatefulWidget {
  const ProviderFindingPage({super.key});

  @override
  State<ProviderFindingPage> createState() => _ProviderFindingPageState();
}

class _ProviderFindingPageState extends State<ProviderFindingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildLoadingArrows() {
    return Semantics(
      label: 'Searching for provider, loading animation',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          int activeArrow = (_controller.value * 3).floor() % 3;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: index == activeArrow
                      ? Colors.deepPurple
                      : Colors.grey.shade400,
                  size: 28,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Back Button
                Align(
                  alignment: Alignment.topLeft,
                  child: Semantics(
                    label: 'Go back',
                    button: true,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 200.h),

                Semantics(
                  label: 'Your booking is being placed. Please wait.',
                  child: const Text(
                    'Your booking is being getting placed, Wait for sometime.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                buildLoadingArrows(),

                const SizedBox(height: 80),

                 Semantics(
                  label: 'Provider details will be sent soon.',
                  child: Text(
                    'Providers details will be send soon',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),

                Semantics(
                  label: 'Cancel booking',
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black26),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
