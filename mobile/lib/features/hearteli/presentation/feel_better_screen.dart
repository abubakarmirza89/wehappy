import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'components.dart';

class FeelBetterScreen extends StatelessWidget {
  const FeelBetterScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: screenPadding,
        children: [
          const SizedBox(height: 52),
          const Icon(
            Icons.favorite,
            color: AppColors.coral,
            size: 66,
          ),
          const SizedBox(height: 22),
          Text(
            'Your nudge is on its way ❤️',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Sometimes reaching out is the first step towards feeling more connected.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.neutralGrey),
          ),
          const SizedBox(height: 36),
          FilledButton(
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  );
}
