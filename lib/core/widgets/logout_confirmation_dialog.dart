import 'package:flutter/material.dart';
import 'app_confirmation_dialog.dart';

/// Logout confirmation dialog that delegates to the reusable AppConfirmationDialog component.
class LogoutConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutConfirmationDialog({super.key, required this.onConfirm});

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return AppConfirmationDialog.show(
      context,
      icon: Icons.logout_rounded,
      title: 'Log out?',
      message:
          'Are you sure you want to log out of your account? You will be returned to the sign-in screen.',
      confirmText: 'Log Out',
      cancelText: 'Cancel',
      isDestructive: true,
    ).then((confirmed) {
      if (confirmed == true) {
        onConfirm();
      }
      return confirmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppConfirmationDialog(
      icon: Icons.logout_rounded,
      title: 'Log out?',
      message:
          'Are you sure you want to log out of your account? You will be returned to the sign-in screen.',
      confirmText: 'Log Out',
      cancelText: 'Cancel',
      isDestructive: true,
      onConfirm: onConfirm,
      onCancel: () => Navigator.pop(context, false),
    );
  }
}
