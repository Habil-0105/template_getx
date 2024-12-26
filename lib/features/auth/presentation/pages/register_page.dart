import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}