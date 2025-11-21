import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_toast.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget({
    required this.phoneController,
    required this.lang,
    required this.onPhoneSubmitted,
    super.key,
  });

  final TextEditingController phoneController;
  final String lang;
  final VoidCallback onPhoneSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Phone Number" : "फोन नंबर",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (phoneController.text.length == 10) {
              onPhoneSubmitted();
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please enter a valid 10-digit phone number."
                    : "कृपया 10 अंकों का वैध फोन नंबर दर्ज करें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Get OTP" : "OTP प्राप्त करें"),
        ),
      ],
    );
  }
}

