import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'core/providers/app_providers.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root application widget.
/// Coordinates theme, separated routing, and separated BLoC providers.
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
