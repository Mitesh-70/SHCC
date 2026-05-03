import 'package:flutter/material.dart';
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
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgSurface,
      leading: leading,
      titleSpacing: leading != null ? 0 : 16,
      title: showBranding ? _buildBranding() : _buildTitle(),
      actions: [
        if (actions != null) ...actions!,
        if (showProfileIcon) _buildProfileAvatar(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _buildBranding() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoWidget(assetPath: logoAsset),
        const SizedBox(width: 10),
        Text(
          AppStrings.appName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(title ?? '', style: AppTextStyles.heading2);
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primaryMuted,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Center(
          child: Text(
            userInitials ?? 'U',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}

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
          width: 32,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (e1, e2, e3) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.local_fire_department_rounded,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
