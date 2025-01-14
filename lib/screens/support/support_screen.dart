import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/haptics.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/custom_bottom_sheet.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedIssue;
  bool _isLoading = false;
  String? _nameError;
  String? _emailError;
  String? _messageError;
  String? _issueError;
  bool _isIssueTypeFocused = false;

  final List<String> _issueTypes = [
    'Account Recovery',
    'Technical Support',
    'Feature Request',
    'Other',
  ];

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showToast(String message, {bool isError = false}) {
    CustomToast.show(context, message, isError: isError);
  }

  void _handleIssueTypeTap() {
    setState(() {
      _isIssueTypeFocused = true;
    });
    _showIssueTypePicker();
  }

  void _showIssueTypePicker() {
    Haptics.mediumImpact();
    CustomBottomSheet.show(
      context: context,
      title: 'Select Issue Type',
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _issueTypes.length,
        itemBuilder: (context, index) {
          final issueType = _issueTypes[index];
          final theme = Theme.of(context);
          final isSelected = issueType == _selectedIssue;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(
              issueType,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: isSelected
                    ? const Color(0xFF00BA88)
                    : theme.brightness == Brightness.dark
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF3D3D3D),
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
            ),
            leading: Icon(
              isSelected ? Iconsax.tick_circle : Iconsax.box,
              color: isSelected
                  ? const Color(0xFF00BA88)
                  : theme.brightness == Brightness.dark
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF3D3D3D),
            ),
            onTap: () {
              setState(() {
                _selectedIssue = issueType;
                _issueError = null;
                _isIssueTypeFocused = false;
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    // Validate fields
    bool hasError = false;

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Please enter your name';
      });
      hasError = true;
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      hasError = true;
    } else if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      hasError = true;
    }

    if (_selectedIssue == null) {
      setState(() {
        _issueError = 'Please select an issue type';
      });
      hasError = true;
    }

    if (_messageController.text.isEmpty) {
      setState(() {
        _messageError = 'Please enter your message';
      });
      hasError = true;
    }

    if (hasError) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _showToast('Message sent successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showToast('Failed to send message', isError: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF28282A)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF28282A)
            : Colors.white,
        title: Text(
          'Support',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF3D3D3D),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: theme.brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF3D3D3D),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help?',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a category below or search for your issue',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF7B7B80)
                    : const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              placeholder: 'Enter your name',
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
              controller: _emailController,
              placeholder: 'Enter your email',
              icon: Iconsax.sms,
              keyboardType: TextInputType.emailAddress,
              error: _emailError,
              onChanged: (value) {
                if (_emailError != null) {
                  setState(() {
                    _emailError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF1C1C1E)
                    : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(15),
                border: _issueError != null
                    ? Border.all(color: Colors.red, width: 1)
                    : _isIssueTypeFocused
                        ? Border.all(
                            color: theme.brightness == Brightness.dark
                                ? const Color(0xFF3D3D3D)
                                : const Color(0xFFDEDEDE),
                            width: 1,
                          )
                        : null,
              ),
              child: GestureDetector(
                onTap: _handleIssueTypeTap,
                behavior: HitTestBehavior.opaque,
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Iconsax.message_question,
                      color: theme.brightness == Brightness.dark
                          ? (_isIssueTypeFocused 
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF7B7B80))
                          : const Color(0xFF3D3D3D),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    labelText: 'Type of Inquiry',
                    labelStyle: GoogleFonts.dmSans(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF99999F)
                          : const Color(0xFF3D3D3D),
                      fontSize: 16,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    errorText: _issueError,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedIssue ?? 'Other',
                        style: GoogleFonts.dmSans(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFF7B7B80)
                              : const Color(0xFF616161),
                          fontSize: 16,
                        ),
                      ),
                      FaIcon(
                        FontAwesomeIcons.chevronDown,
                        size: 16,
                        color: theme.brightness == Brightness.dark
                            ? (_isIssueTypeFocused 
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF7B7B80))
                            : const Color(0xFF3D3D3D),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_issueError != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  _issueError!,
                  style: GoogleFonts.dmSans(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _messageController,
              placeholder: 'Enter your message',
              icon: Iconsax.message,
              maxLines: 5,
              error: _messageError,
              onChanged: (value) {
                if (_messageError != null) {
                  setState(() {
                    _messageError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _handleSubmit,
              text: _isLoading ? 'Sending...' : 'Submit',
              isLoading: _isLoading,
              color: const Color(0xFF3D3D3D),
              labelColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
