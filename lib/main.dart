import 'package:aplikasimu/views/dashboard.dart';
import 'package:aplikasimu/views/login_view.dart';
import 'package:aplikasimu/views/pesanView.dart';
import 'package:aplikasimu/views/register_user_view.dart';
import 'package:aplikasimu/views/sushikuView.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    MaterialApp(
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegisterUserView(),
        '/dashboard': (context) => DashboardView(),
        '/login': (context) => LoginView(),
        '/sushi': (context) => SushikuView(),
        '/pesan': (context) => PesanView(),
        },
    ),
  );
}