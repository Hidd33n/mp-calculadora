import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mpcalcu/pages/home_screen.dart';
import 'package:mpcalcu/pages/number_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(key: key); // Corrección en la declaración del constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Definir rutas
      routes: {
        '/': (context) => const HomeScreen(),
        '/number': (context) => const NumberScreen(),
      },
      initialRoute: '/', // Ruta inicial
      // Resto de las propiedades del MaterialApp
    );
  }
}
