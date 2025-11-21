import 'package:flutter/material.dart';
import '../widgets/phone_input_widget.dart';
import '../widgets/otp_input_widget.dart';
import '../widgets/info_input_widget.dart';
import '../../../../shared/widgets/custom_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.onLoginSuccess,
    super.key,
  });

  final ValueChanged<Map<String, dynamic>> onLoginSuccess;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String lang = 'en';
  String authStep = 'phone';

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(blurRadius: 10, color: Colors.black12),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("🥬", style: TextStyle(fontSize: 50)),
                Text(
                  lang == 'en' ? "OnlineMandi" : "ऑनलाइनमंडी",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (authStep == 'phone')
                  PhoneInputWidget(
                    phoneController: phoneController,
                    lang: lang,
                    onPhoneSubmitted: () {
                      setState(() => authStep = 'otp');
                    },
                  ),
                if (authStep == 'otp')
                  OtpInputWidget(
                    otpController: otpController,
                    lang: lang,
                    onOtpSubmitted: () {
                      setState(() => authStep = 'info');
                    },
                  ),
                if (authStep == 'info')
                  InfoInputWidget(
                    nameController: nameController,
                    emailController: emailController,
                    addressController: addressController,
                    lang: lang,
                    onInfoSubmitted: (Map<String, String> info) {
                      final Map<String, dynamic> user = <String, dynamic>{
                        "phone": phoneController.text,
                        ...info,
                      };
                      CustomToast.show(
                        context,
                        message: lang == 'en'
                            ? "Registration successful!"
                            : "पंजीकरण सफल!",
                        icon: Icons.check_circle_outline,
                        backgroundColor: Colors.green.shade700,
                      );
                      widget.onLoginSuccess(user);
                    },
                  ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() => lang = lang == 'en' ? 'hi' : 'en');
                  },
                  child: Text(
                    lang == 'en' ? "हिंदी" : "English",
                    style: TextStyle(color: Colors.green.shade700),
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
