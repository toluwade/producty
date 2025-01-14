import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_toast.dart';
import '../../../widgets/country_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> _selectedUsageTypes = [];
  String? _nameError;
  Country? _selectedCountry;

  void _toggleUsageType(String usageType) {
    setState(() {
      if (_selectedUsageTypes.contains(usageType)) {
        _selectedUsageTypes.remove(usageType);
      } else {
        _selectedUsageTypes.add(usageType);
      }
    });
  }

  void _showToast(String message, {bool isError = false}) {
    CustomToast.show(context, message, isError: isError);
  }

  void _selectCountry() {
    showCountryPickerBottomSheet(
      context,
      isDark: Theme.of(context).brightness == Brightness.dark,
      onCountrySelected: (country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Please enter your full name';
      });
      return;
    }

    if (_selectedUsageTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one usage type',
            style: GoogleFonts.dmSans(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // All validation passed, navigate to dashboard
    _showToast('Profile saved successfully');
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            '🎉 Yay!, Lets complete your profile',
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/profile.json',
                  width: 300,
                  height: 100,
                  repeat: true,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tell Us About Yourself',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Help us personalize your experience',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _nameController,
                  placeholder: 'Enter your full name',
                  icon: Iconsax.user,
                  error: _nameError,
                  onChanged: (value) {
                    if (_nameError != null) {
                      setState(() {
                        _nameError = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: TextEditingController(
                    text: _selectedCountry != null
                        ? '${_selectedCountry!.flag} ${_selectedCountry!.name}'
                        : 'Select Country',
                  ),
                  icon: Iconsax.global,
                  placeholder: 'Select Country',
                  onTap: _selectCountry,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  icon: Iconsax.call,
                  placeholder: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E)
                        : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'How do you plan to use Producty?',
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Personal',
                          style: GoogleFonts.dmSans(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        value: _selectedUsageTypes.contains('Personal'),
                        onChanged: (bool? value) =>
                            _toggleUsageType('Personal'),
                        activeColor: isDark ? Colors.white : Colors.black,
                        checkColor: isDark ? Colors.black : Colors.white,
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Work',
                          style: GoogleFonts.dmSans(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        value: _selectedUsageTypes.contains('Work'),
                        onChanged: (bool? value) => _toggleUsageType('Work'),
                        activeColor: isDark ? Colors.white : Colors.black,
                        checkColor: isDark ? Colors.black : Colors.white,
                      ),
                      CheckboxListTile(
                        title: Text(
                          'Education',
                          style: GoogleFonts.dmSans(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        value: _selectedUsageTypes.contains('Education'),
                        onChanged: (bool? value) =>
                            _toggleUsageType('Education'),
                        activeColor: isDark ? Colors.white : Colors.black,
                        checkColor: isDark ? Colors.black : Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onPressed: _handleSubmit,
                  text: 'Complete Profile',
                  color: const Color(0xFF3D3D3D),
                  labelColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
