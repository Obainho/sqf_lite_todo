import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_provider_starter/models/loading_screen.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key, required this.context}) : super(key: key);
  final BuildContext context;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    widget.context.read<LoadScreen>().doneLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Loading...",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
