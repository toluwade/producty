import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../auth/auth_screen.dart';
import '../../widgets/theme_settings_sheet.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/week_stripe.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  List<DateTime> _getWeekDates() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1C1C1E) : const Color(0xFFF1F1F1),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemNavigationBarColor:
              isDarkMode ? Colors.grey[900] : const Color(0xFFF1F1F1),
          systemNavigationBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 20.sp,
                ),
                Text(
                  'Back',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        title: null,
      ),
      body: Column(
        children: [
          SizedBox(height: 5.h, width: 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              height: 68,
              child: WeekStripe(
                pageController: PageController(initialPage: 0),
                selectedDate: DateTime.now(),
                onDateSelected: (_) {},
                isDarkMode: isDarkMode,
                isRefreshing: false,
                dates: _getWeekDates(),
                currentPageIndex: 0,
                onPageChanged: (_) {},
                isStatic: true,
              ),
            ),
          ),
          SizedBox(height: 15.h, width: 2),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w)
                  .copyWith(bottom: MediaQuery.of(context).padding.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF28282A)
                      : const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12.h),
                    Center(
                      child: Container(
                        width: 70.w,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? const Color(0xFF3D3D3D)
                              : const Color(0xFFEAEAEA),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 30.h),
                            CircleAvatar(
                              radius: 23,
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 23,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'john.doe@example.com',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                children: [
                                  _buildSection(
                                      context,
                                      'Account Settings',
                                      [
                                        _buildMenuItem(context, 'Edit Profile',
                                            Iconsax.user_edit, () {
                                          _showEditProfileSheet(context);
                                        }),
                                        _buildMenuItem(
                                            context,
                                            'Notification Settings',
                                            Iconsax.notification, () {
                                          _showNotificationSettingsSheet(
                                              context);
                                        }),
                                      ],
                                      isDarkMode),
                                  SizedBox(height: 14.h),
                                  _buildSection(
                                      context,
                                      'App Settings',
                                      [
                                        _buildMenuItem(context,
                                            'Theme Settings', Iconsax.moon, () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                const ThemeSettingsSheet(),
                                          );
                                        }),
                                        _buildMenuItem(
                                            context,
                                            'Help & Support',
                                            Iconsax.message_question, () {
                                          Navigator.pushNamed(
                                              context, '/support');
                                        }),
                                      ],
                                      isDarkMode),
                                  SizedBox(height: 14.h),
                                  _buildSection(
                                      context,
                                      'Other',
                                      [
                                        _buildMenuItem(
                                            context,
                                            'Privacy Policy',
                                            Iconsax.shield_tick, () {
                                          _showComingSoonToast(context);
                                        }),
                                        _buildMenuItem(
                                            context,
                                            'Terms of Service',
                                            Iconsax.document, () {
                                          _showComingSoonToast(context);
                                        }),
                                      ],
                                      isDarkMode),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40.h,
                                    child: ElevatedButton(
                                      onPressed: () => _handleLogout(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFFFD4D4),
                                        foregroundColor:
                                            const Color(0xFFFF0000),
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: Text(
                                        'Log Out',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFFF0000),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool taskNotifications = true;
          bool focusNotifications = true;
          bool mindNotifications = true;

          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF28282A)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildNotificationOption(
                  'Task Notifications',
                  taskNotifications,
                  (value) => setState(() => taskNotifications = value),
                  isDarkMode,
                ),
                _buildNotificationOption(
                  'Focus Notifications',
                  focusNotifications,
                  (value) => setState(() => focusNotifications = value),
                  isDarkMode,
                ),
                _buildNotificationOption(
                  'Mind Notifications',
                  mindNotifications,
                  (value) => setState(() => mindNotifications = value),
                  isDarkMode,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationOption(
    String title,
    bool value,
    Function(bool) onChanged,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          CustomCheckbox(
            value: value,
            onChanged: onChanged,
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> items, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF3D3D3D) : const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w).copyWith(top: 14.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap,
      {bool isLogout = false}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
      leading: Icon(
        icon,
        size: 20.sp,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showComingSoonToast(BuildContext context) {
    CustomToast.show(context, 'Coming soon!');
  }

  void _showEditProfileSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController(text: 'John Doe');
    final emailController = TextEditingController(text: 'john.doe@example.com');

    CustomBottomSheet.show(
      context: context,
      title: 'Edit Profile',
      isScrollControlled: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: nameController,
            placeholder: 'Full Name',
            icon: Iconsax.user_edit,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            controller: emailController,
            placeholder: 'Email Address',
            icon: Iconsax.direct_right,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 40.h,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF3D3D3D) : Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsSheet(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool taskNotifications = true;
    bool reminderNotifications = true;
    bool updateNotifications = true;

    CustomBottomSheet.show(
      context: context,
      title: 'Notification Settings',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'Task Notifications',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                value: taskNotifications,
                onChanged: (value) {
                  setState(() => taskNotifications = value);
                },
                activeColor: const Color(0xFF3D3D3D),
              ),
              SwitchListTile(
                title: Text(
                  'Reminder Notifications',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                value: reminderNotifications,
                onChanged: (value) {
                  setState(() => reminderNotifications = value);
                },
                activeColor: const Color(0xFF3D3D3D),
              ),
              SwitchListTile(
                title: Text(
                  'Update Notifications',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                value: updateNotifications,
                onChanged: (value) {
                  setState(() => updateNotifications = value);
                },
                activeColor: const Color(0xFF3D3D3D),
              ),
            ],
          );
        },
      ),
    );
  }
}
