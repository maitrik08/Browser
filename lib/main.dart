import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomeScreen.dart';
void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<WebProvider>(create: (context) => WebProvider())
          ],
          child: MyApp()
      )
  );
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Browser',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: HomeScreen()
    );
  }
}