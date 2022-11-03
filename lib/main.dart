import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_provider_starter/models/loading_screen.dart';
import 'package:sqlite_provider_starter/pages/loading_view.dart';
import 'package:sqlite_provider_starter/routes/routes.dart';
import 'package:sqlite_provider_starter/services/todo_service.dart';
import 'package:sqlite_provider_starter/services/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoadScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserService(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoService(),
        )
      ],
      child: Consumer<LoadScreen>(
        builder: (context, value, child) {
          return value.doneLoading
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: RouteManager.loginPage,
                  onGenerateRoute: RouteManager.generateRoute,
                )
              : LoadingView(context: context);
        },
      ),
    );
  }
}
