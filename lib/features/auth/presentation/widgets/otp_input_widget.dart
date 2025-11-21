import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_toast.dart';

class OtpInputWidget extends StatelessWidget {
  const OtpInputWidget({
    required this.otpController,
    required this.lang,
    required this.onOtpSubmitted,
    super.key,
  });

  final TextEditingController otpController;
  final String lang;
  final VoidCallback onOtpSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: otpController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: lang == 'en' ? "Enter OTP" : "OTP दर्ज करें",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (otpController.text.length == 6) {
              onOtpSubmitted();
            } else {
              CustomToast.show(
                context,
                message: lang == 'en'
                    ? "Please enter a valid 6-digit OTP."
                    : "कृपया 6 अंकों का वैध OTP दर्ज करें।",
                icon: Icons.error_outline,
                backgroundColor: Colors.green.shade900,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text(lang == 'en' ? "Verify" : "सत्यापित करें"),
        ),
      ],
    );
  }
}

