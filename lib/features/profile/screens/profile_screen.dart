import 'package:flutter/material.dart';
import 'package:shortly_customer/core/utils/custom_spacers.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Top Profile Header
            Container(
              height: 260.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Semantics(
                label: 'User profile information',
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: const NetworkImage(
                          'https://randomuser.me/api/portraits/men/46.jpg'),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Abhishek Chauhan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      "+91 8099950828",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Text(
                      "Noida Sector 128 - Uttar Pradesh",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),

            CustomSpacers.height20,

            /// Action List
            Semantics(
              label: 'Edit profile',
              button: true,
              child: _buildListTile(Icons.edit, "Edit Profile", () {
                CustomNavigator.pushTo(context, AppPages.editprofilescreen);
              }),
            ),

            Semantics(
              label: 'Get help',
              button: true,
              child: _buildListTile(Icons.help, "Get Help", () {
                // Add help logic here
              }),
            ),

            Semantics(
              label: 'Logout from app',
              button: true,
              child: _buildListTile(Icons.logout, "Logout", () {
                CustomNavigator.pushReplace(context, AppPages.login);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.deepPurple, size: 26),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
