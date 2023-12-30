import 'package:HLSA/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? "";
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? "";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final storage = FlutterSecureStorage();
  String? supabaseToken = await storage.read(key: 'supabase_token');
  debugPrint(
      "=========================================================Supabase token:" +
          supabaseToken.toString());
  runApp(MyApp(
    supabaseToken: supabaseToken,
  ));
}

class MyApp extends StatelessWidget {
  final String? supabaseToken;

  const MyApp({this.supabaseToken, super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance app',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(18, 86, 196, 1),
        scaffoldBackgroundColor: Color.fromRGBO(253, 227, 80, 1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(18, 86, 196, 1),
          primary: Color.fromRGBO(18, 86, 196, 1),
          secondary: Color.fromRGBO(253, 227, 80, 1),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(
        supabaseToken: supabaseToken,
      ),
    );
  }
}
