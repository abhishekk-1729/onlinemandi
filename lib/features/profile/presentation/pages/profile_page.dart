import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_toast.dart';

/// Widget to display and edit user profile information.
class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.user,
    required this.lang,
    required this.onLogout,
    required this.onProfileUpdated,
    super.key,
  });

  final Map<String, dynamic> user;
  final String lang;
  final VoidCallback onLogout;
  final ValueChanged<Map<String, dynamic>> onProfileUpdated;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user['name'] as String,
    );
    _emailController = TextEditingController(
      text: widget.user['email'] as String,
    );
    _addressController = TextEditingController(
      text: widget.user['address'] as String,
    );
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      _nameController.text = widget.user['name'] as String;
      _emailController.text = widget.user['email'] as String;
      _addressController.text = widget.user['address'] as String;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // If exiting edit mode without saving, reset controllers to current widget.user data
        _nameController.text = widget.user['name'] as String;
        _emailController.text = widget.user['email'] as String;
        _addressController.text = widget.user['address'] as String;
      }
    });
  }

  void _saveProfile() {
    final Map<String, dynamic> updatedUser = <String, dynamic>{
      ...widget.user, // Keep existing fields like 'phone'
      "name": _nameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
    };

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) {
      CustomToast.show(
        context,
        message: widget.lang == 'en'
            ? "Please fill all fields."
            : "कृपया सभी फ़ील्ड भरें।",
        icon: Icons.error_outline,
        backgroundColor: Colors.green.shade900,
      );
      return;
    }

    widget.onProfileUpdated(updatedUser);
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              widget.user['name'] as String,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    _isEditing
                        ? Column(
                            children: <Widget>[
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: widget.lang == 'en'
                                      ? "Name"
                                      : "नाम",
                                  prefixIcon: const Icon(Icons.person),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: widget.lang == 'en'
                                      ? "Address"
                                      : "पता",
                                  prefixIcon: const Icon(Icons.location_on),
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        widget.lang == 'en' ? "Save" : "सहेजें",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _toggleEditMode,
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        side: const BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                      child: Text(
                                        widget.lang == 'en'
                                            ? "Cancel"
                                            : "रद्द करें",
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(
                                  Icons.person,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Name" : "नाम",
                                ),
                                subtitle: Text(widget.user['name'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                title: const Text("Email"),
                                subtitle: Text(widget.user['email'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.phone,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Phone" : "फ़ोन",
                                ),
                                subtitle: Text(widget.user['phone'] as String),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  widget.lang == 'en' ? "Address" : "पता",
                                ),
                                subtitle: Text(
                                  widget.user['address'] as String,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _toggleEditMode,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    widget.lang == 'en'
                                        ? "Edit Profile"
                                        : "प्रोफ़ाइल संपादित करें",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onLogout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(widget.lang == 'en' ? "Log Out" : "लॉग आउट करें"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

