import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app.dart';
import '../../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isAdmin;
  const ProfileScreen({super.key, this.isAdmin = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const name = 'Sarah Jenkins';
    const email = 'sarah.jenkins@email.com';
    // Clean, professional portrait image
    const imageUrl = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : const Color(0xFFF4F3F0),
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: AppTextStyles.heading1.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    size: 18, color: AppColors.textPrimaryColor(context)),
                onPressed: () => Navigator.pop(context))
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          // Avatar & Name Section
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.primaryMuted,
                        child: const Center(
                          child: Text(
                            'SJ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: AppTextStyles.heading1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppTextStyles.bodySecondary.copyWith(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : const Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Group 1: Navigation Actions
          _buildCardGroup(
            context,
            dividerIndent: 60,
            children: [
              _buildListTile(
                context,
                title: 'Edit Profile',
                leadingIcon: CupertinoIcons.pencil,
                iconBgColor: const Color(0xFF3B82F6), // Vibrant Blue
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Payment Methods',
                leadingIcon: CupertinoIcons.creditcard,
                iconBgColor: const Color(0xFF8B5CF6), // Purple
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Settings',
                leadingIcon: CupertinoIcons.settings,
                iconBgColor: const Color(0xFF10B981), // Green
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(isAdmin: widget.isAdmin),
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                title: 'Help',
                leadingIcon: CupertinoIcons.question_circle,
                iconBgColor: const Color(0xFFF59E0B), // Orange
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Group 2: App Settings
          _buildSectionHeader('App Settings', context),
          const SizedBox(height: 8),
          _buildCardGroup(
            context,
            dividerIndent: 16,
            children: [
              _buildListTile(
                context,
                title: 'Notifications',
                trailing: CupertinoSwitch(
                  value: _notificationsEnabled,
                  activeColor: const Color(0xFF34C759), // iOS Green
                  onChanged: (val) {
                    setState(() {
                      _notificationsEnabled = val;
                    });
                  },
                ),
              ),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, currentMode, _) {
                  final isCurrentlyDark = currentMode == ThemeMode.dark;
                  return _buildListTile(
                    context,
                    title: 'Dark Mode',
                    trailing: CupertinoSwitch(
                      value: isCurrentlyDark,
                      activeColor: const Color(0xFFF43F5E), // Pink/Red toggle as requested in mockup
                      onChanged: (val) {
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  );
                },
              ),
              _buildListTile(
                context,
                title: 'Language',
                trailingIcon: CupertinoIcons.chevron_right,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Group 3: Account
          _buildSectionHeader('Account', context),
          const SizedBox(height: 8),
          _buildCardGroup(
            context,
            dividerIndent: 16,
            children: [
              _buildListTile(
                context,
                title: 'My Orders',
                trailingIcon: CupertinoIcons.chevron_right,
                onTap: () {},
              ),
              _buildListTile(
                context,
                title: 'Addresses',
                trailingIcon: CupertinoIcons.chevron_right,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Logout Button
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: Text(
              'Log Out',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.heading2.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1C1C1E),
        ),
      ),
    );
  }

  Widget _buildCardGroup(BuildContext context, {required List<Widget> children, double dividerIndent = 16}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: List.generate(children.length, (index) {
            return Column(
              children: [
                children[index],
                if (index < children.length - 1)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: dividerIndent,
                    color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5EA),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    IconData? leadingIcon,
    Color? iconBgColor,
    Widget? trailing,
    IconData? trailingIcon = CupertinoIcons.chevron_right,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget? leadingWidget;
    if (leadingIcon != null) {
      leadingWidget = Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(
          leadingIcon,
          color: Colors.white,
          size: 18,
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (leadingWidget != null) ...[
                leadingWidget,
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (trailing != null)
                trailing
              else if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  color: isDark ? const Color(0xFF48484A) : const Color(0xFFC7C7CC),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
