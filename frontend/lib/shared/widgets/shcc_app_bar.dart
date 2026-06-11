import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

class ShccAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBranding;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showProfileIcon;
  final VoidCallback? onProfileTap;
  final String? userInitials;
  final String? profileImageUrl;
  final String? logoAsset;

  const ShccAppBar({
    super.key,
    this.title,
    this.showBranding = true,
    this.actions,
    this.leading,
    this.showProfileIcon = true,
    this.onProfileTap,
    this.userInitials,
    this.profileImageUrl = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Keep status bar icons matching current theme
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
    ));

    return Container(
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor ?? theme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
              ? AppColors.border.withValues(alpha: 0.6)
              : AppColors.lightBorder.withValues(alpha: 0.8),
            width: 0.5,
          ),
        ),
        boxShadow: isDark
          ? null
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.only(
              left: leading != null ? 4 : 16,
              right: 12,
            ),
            child: Row(children: [
              ?leading,
              if (showBranding) _buildBranding(context) else _buildTitle(context),
              const Spacer(),
              if (actions != null) ...actions!,
              if (showProfileIcon) _buildProfileAvatar(context),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      _LogoWidget(assetPath: logoAsset),
      const SizedBox(width: 10),
      Text(
        AppStrings.appName,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textPrimary : AppColors.lightTextPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
    ]);
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title ?? '',
      style: AppTextStyles.heading2.copyWith(
        color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.textPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        width: 36, height: 36,
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryMuted,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.45), width: 1.5),
        ),
        child: ClipOval(
          child: profileImageUrl != null && profileImageUrl!.isNotEmpty
            ? Image.network(
                profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 20,
                ),
              )
            : const Icon(
                Icons.person,
                color: AppColors.primary,
                size: 20,
              ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 0.5);
}

// ── Logo widget ───────────────────────────────────────────────────────────────
class _LogoWidget extends StatelessWidget {
  final String? assetPath;
  const _LogoWidget({this.assetPath});

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          assetPath!,
          width: 32, height: 32,
          fit: BoxFit.contain,
          errorBuilder: (ctx, err, stack) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() => Container(
    width: 32, height: 32,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(
      Icons.local_fire_department_rounded,
      color: Colors.white, size: 18),
  );
}