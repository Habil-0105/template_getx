import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      /// Melakukan pengecekan untuk dibawa ke login atau home
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}