import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'providers/app_providers.dart';
import 'repositories/progress_repository.dart';
import 'theme/app_theme.dart';
import 'widgets/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local (offline-first) veritabanını başlat
  await Hive.initFlutter();
  final progressRepository = ProgressRepository();
  await progressRepository.init();

  runApp(
    ProviderScope(
      overrides: [
        progressRepositoryProvider.overrideWithValue(progressRepository),
      ],
      child: const KuryeSahadaApp(),
    ),
  );
}

class KuryeSahadaApp extends StatelessWidget {
  const KuryeSahadaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kurye Sahada',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      home: const MainNavigation(),
    );
  }
}
