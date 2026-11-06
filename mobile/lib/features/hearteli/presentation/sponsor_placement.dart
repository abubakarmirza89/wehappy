import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/network/api_client.dart';
import '../../../core/config/app_config.dart';

class SponsorPlacement extends StatefulWidget {
  const SponsorPlacement({
    super.key,
    required this.apiClient,
    required this.payload,
    this.child,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> payload;
  final Widget? child;
  @override
  State<SponsorPlacement> createState() => _SponsorPlacementState();
}

class _SponsorPlacementState extends State<SponsorPlacement> {
  Timer? timer, expiryTimer;
  @override
  void initState() {
    super.initState();
    final end = DateTime.tryParse('${widget.payload['ends_at']}');
    if (end != null) {
      final remaining = end.difference(DateTime.now());
      if (remaining.isNegative) {
        expired = true;
      } else {
        expiryTimer = Timer(remaining, () {
          if (mounted) setState(() => expired = true);
        });
      }
    }
  }

  bool shown = false, expired = false;
  @override
  void dispose() {
    timer?.cancel();
    expiryTimer?.cancel();
    super.dispose();
  }

  Future<bool> event(String kind) async {
    try {
      await widget.apiClient.post(
        '/api/users/sponsor-events/',
        body: {
          'event_id': widget.payload['event_id'],
          'event_type': kind,
          'visible_fraction': .5,
          'visible_ms': 1000,
        },
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: ValueKey(widget.payload['event_id']),
        onVisibilityChanged: (info) {
          timer?.cancel();
          if (info.visibleFraction >= .5 && !shown && !expired)
            timer = Timer(const Duration(seconds: 1), () async {
              if (!mounted ||
                  ModalRoute.of(context)?.isCurrent != true ||
                  WidgetsBinding.instance.lifecycleState !=
                      AppLifecycleState.resumed) return;
              final valid = await event('impression');
              if (mounted)
                setState(() {
                  shown = valid;
                  expired = !valid;
                });
            });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!expired)
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 4),
                child: Text(
                  'Sponsored',
                  semanticsLabel: 'Paid sponsorship',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            if (widget.child != null)
              widget.child!
            else if (!expired)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.payload['creative_url'] != null)
                        Image.network(
                          Uri.parse(AppConfig.apiBaseUrl)
                              .resolve('${widget.payload['creative_url']}')
                              .toString(),
                          height: 70,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      Text('${widget.payload['sponsor_name']}'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
}
