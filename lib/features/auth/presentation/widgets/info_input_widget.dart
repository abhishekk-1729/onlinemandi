import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_toast.dart';

class InfoInputWidget extends StatelessWidget {
  const InfoInputWidget({
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.lang,
    required this.onInfoSubmitted,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final String lang;
  final ValueChanged<Map<String, String>> onInfoSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Name" : "नाम",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Address" : "पता",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final Map<String, String> currentInfo = <String, String>{
              "name": nameController.text,
              "email": emailController.text,
              "address": addressController.text,
            };

            if (currentInfo.values.every((String e) => e.isNotEmpty)) {
              onInfoSubmitted(currentInfo);
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please fill all fields."
                    : "कृपया सभी फ़ील्ड भरें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Submit" : "जमा करें"),
        ),
      ],
    );
  }
}

