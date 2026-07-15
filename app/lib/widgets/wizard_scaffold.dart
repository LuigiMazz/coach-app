import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shared shell for the step-flow screens (exercise creation, registration,
/// assign program, new athlete/program forms) — mirrors the modal pattern
/// from the wireframe: back/close, centered title, optional step counter,
/// scrollable body, sticky footer CTA.
class WizardScaffold extends StatelessWidget {
  final String title;
  final String? stepLabel;
  final Widget body;
  final String ctaLabel;
  final VoidCallback? onCta;
  final bool ctaEnabled;
  final Widget? footerExtra;
  final VoidCallback? onBack;
  final bool showClose;

  const WizardScaffold({
    super.key,
    required this.title,
    this.stepLabel,
    required this.body,
    required this.ctaLabel,
    this.onCta,
    this.ctaEnabled = true,
    this.footerExtra,
    this.onBack,
    this.showClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            splashRadius: 18,
                            icon: Icon(
                              showClose ? Icons.close : Icons.arrow_back,
                              size: 20,
                              color: AppColors.textTertiary,
                            ),
                            onPressed:
                                onBack ??
                                () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 32,
                          child: Text(
                            stepLabel ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: body,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: ctaEnabled ? onCta : null,
                            child: Text(ctaLabel),
                          ),
                        ),
                        if (footerExtra != null) ...[
                          const SizedBox(height: 10),
                          footerExtra!,
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Labeled form field wrapper used across wizard steps.
class WizardField extends StatelessWidget {
  final String label;
  final Widget child;

  const WizardField({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
