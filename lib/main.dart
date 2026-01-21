import 'package:aplikasimu/views/dashboard.dart';
import 'package:aplikasimu/views/login_view.dart';
import 'package:aplikasimu/views/register_user_view.dart';
import 'package:flutter/material.dart';
import 'package:aplikasimu/widgets/alert.dart';


void main() {
  runApp(
    MaterialApp(
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegisterUserView(),
        '/dashboard': (context) => DashboardView(),
        '/login': (context) => LoginView(),
        },
    ),
  );
}