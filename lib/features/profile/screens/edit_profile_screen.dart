import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/utils/custom_spacers.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/route/custom_navigator.dart';
import 'package:shortly_customer/ui/atoms/my_textfield.dart';
import 'package:shortly_customer/ui/molecules/custom_button.dart';
import 'package:shortly_customer/features/profile/data/edit_profile_provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => CustomNavigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Consumer<EditProfileProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Picker
                  Semantics(
                    label: 'Tap to change profile picture',
                    child: GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          provider.updateImage(File(pickedFile.path));
                        }
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: provider.profileImage != null
                            ? FileImage(provider.profileImage!)
                            : null,
                        child: provider.profileImage == null
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),

                  CustomSpacers.height30,

                  // Name
                  Semantics(
                    label: 'Enter your name',
                    child: MyTextfield(
                      labelText: "Name",
                      controller: TextEditingController(text: provider.name),
                      type: TextInputType.name,
                      errorText: provider.nameError,
                      onChanged: provider.updateName,
                    ),
                  ),
                  CustomSpacers.height20,

                  // Mobile
                  Semantics(
                    label: 'Enter your mobile number',
                    child: MyTextfield(
                      labelText: "Mobile Number",
                      controller: TextEditingController(text: provider.mobile),
                      type: TextInputType.phone,
                      errorText: provider.phoneError,
                      onChanged: provider.updateMobile,
                    ),
                  ),
                  CustomSpacers.height20,

                  // Address
                  Semantics(
                    label: 'Enter your address',
                    child: MyTextfield(
                      labelText: "Address",
                      controller: TextEditingController(text: provider.address),
                      type: TextInputType.streetAddress,
                      errorText: provider.addressError,
                      onChanged: provider.updateAddress,
                    ),
                  ),

                  CustomSpacers.height40,

                  // Save Button
                  Semantics(
                    label: 'Save profile changes',
                    button: true,
                    child: CustomButton(
                      dHeight: 55.h,
                      dWidth: double.infinity,
                      bgColor: Colors.black,
                      dCornerRadius: 16,
                      strButtonText: "Save Changes",
                      buttonAction: () {
                        if (provider.validateFields()) {
                          print('Saved Name: ${provider.name}');
                          print('Saved Mobile: ${provider.mobile}');
                          print('Saved Address: ${provider.address}');
                          print('Image path: ${provider.profileImage?.path}');

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated successfully!')),
                          );

                          CustomNavigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
