import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/seat_map_screen.dart';
import 'presentation/viewmodels/seat_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SeatViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SeatMapScreen(),
      ),
    );
  }
}
