import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'shared/constants/app_constants.dart';
import 'shared/utils/responsive_config.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(
        ResponsiveConfig.designWidth,
        ResponsiveConfig.designHeight,
      ),
      minTextAdapt: ResponsiveConfig.minTextAdapt,
      splitScreenMode: ResponsiveConfig.splitScreenMode,
      builder: (context, child) => MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
