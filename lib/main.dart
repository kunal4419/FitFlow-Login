import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'auth/auth_controller.dart';
import 'controllers/workout_session_controller.dart';
import 'repositories/auth_repository.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  // Create WorkoutSessionController and load saved session
  final sessionController = WorkoutSessionController();
  await sessionController.loadSessionFromStorage();
  
  runApp(FitFlowApp(sessionController: sessionController));
}

class FitFlowApp extends StatelessWidget {
  final WorkoutSessionController sessionController;
  
  const FitFlowApp({super.key, required this.sessionController});

  @override
  Widget build(BuildContext context) {
    // Check if Supabase is configured
    final configError = SupabaseConfig.getConfigError();
    if (configError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Configuration Error',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    configError,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Please see SETUP_GUIDE.md for instructions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Supabase is configured - initialize app with Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthController(
            AuthRepository(Supabase.instance.client),
          ),
        ),
        ChangeNotifierProvider.value(
          value: sessionController,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: '.SF Pro Display',
          ),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}

