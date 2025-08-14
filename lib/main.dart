import 'package:ecodataatlas/constants/sizes.dart';
import 'package:ecodataatlas/features/settings/repos/settings_repo.dart';
import 'package:ecodataatlas/features/settings/view_models/settings_view_model.dart';
import 'package:ecodataatlas/router/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Warning: Firebase initialization failed: $e');
    // Firebase 초기화 실패 시에도 앱은 계속 실행
  }

  final preferences = await SharedPreferences.getInstance();
  final repository = SettingsRepository(preferences);

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith(() => SettingsViewModel(repository)),
      ],
      child: const EcoDataAtlasApp(),
    ),
  );
}

class EcoDataAtlasApp extends ConsumerWidget {
  const EcoDataAtlasApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'EcoDataAtlas',
      themeMode: ref.watch(settingsProvider).darkmode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: Typography.blackMountainView,
        scaffoldBackgroundColor: Color(0xFFECE6C2),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Color(0xFFECE6C2),
          surfaceTintColor: Color(0xFFECE6C2),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size20,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          elevation: 2,
          color: Color(0xFFECE6C2),
        ),
        primaryColor: const Color(0xFFFEA6F6),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFEA6F6),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade500,
        ),
        listTileTheme: const ListTileThemeData(iconColor: Colors.black),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: Typography.whiteMountainView,
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          foregroundColor: Color(0xFFECE6C2),
          backgroundColor: Colors.grey.shade900,
          surfaceTintColor: Colors.grey.shade900,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Color(0xFFECE6C2),
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
          actionsIconTheme: IconThemeData(color: Color(0xFFECE6C2)),
          iconTheme: IconThemeData(color: Color(0xFFECE6C2)),
        ),
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.grey.shade900),
        primaryColor: const Color(0xFFFEA6F6),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFFEA6F6),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade500,
        ),
        useMaterial3: false,
      ),
    );
  }
}
