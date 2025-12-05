import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/usecases/get_profiles.dart';
import 'presentation/providers/swipe_provider.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SwipeProvider(GetProfiles(ProfileRepositoryImpl())),
      child: MaterialApp(
        title: 'マッチングアプリ',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
