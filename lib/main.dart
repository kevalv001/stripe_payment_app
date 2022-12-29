import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51M4HYcSGi5DRanM6sl0f2OZ7SAkLS2sNw32JiRypmWMEHcXmpBybQXNqkTzhh81sx5zogxbw4JFqkMAjm2wHn4Hc00dZ895P1m';
  //await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.blue,
      home: HomePage(),
    );
  }
}

Color primaryColor = Colors.blue.shade900;
Color blueShade50 = Colors.blue.shade400;
