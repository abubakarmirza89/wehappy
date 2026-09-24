import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

const screenPadding = EdgeInsets.symmetric(horizontal: 22, vertical: 18);

class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.height = 52,
    this.alignment = Alignment.centerLeft,
  });
  final double height;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Hearteli. Know when to be there.',
    child: Image.asset(
      'assets/brand/hearteli_master_logo_transparent.png',
      height: height,
      alignment: alignment,
      fit: BoxFit.contain,
    ),
  );
}

class HearteliCard extends StatelessWidget {
  const HearteliCard({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: color == Colors.white ? const Color(0xFFE7EDF5) : color,
      ),
    ),
    child: child,
  );
}

class PageIntro extends StatelessWidget {
  const PageIntro({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      if (subtitle != null) ...[
        const SizedBox(height: 7),
        Text(
          subtitle!,
          style: const TextStyle(color: AppColors.neutralGrey, fontSize: 15),
        ),
      ],
    ],
  );
}

class StatusPanel extends StatelessWidget {
  const StatusPanel({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.action,
    this.onAction,
  });
  final String message;
  final IconData icon;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => HearteliCard(
    color: AppColors.softBlue,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.ink),
        const SizedBox(height: 8),
        Text(message),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    ),
  );
}

class LabelRow extends StatelessWidget {
  const LabelRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.color = AppColors.blush,
    this.trailing,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color color;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 21, color: AppColors.coral),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.neutralGrey,
              ),
            ),
      trailing:
          trailing ??
          (onTap == null
              ? null
              : const Icon(Icons.chevron_right, color: AppColors.neutralGrey)),
    ),
  );
}

void showCalmMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: AppColors.ink),
  );
}

List<dynamic> items(dynamic data) => data is List
    ? data
    : data is Map
    ? (data['results'] as List? ?? [])
    : [];
