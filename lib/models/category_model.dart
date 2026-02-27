import 'package:flutter/material.dart';

class Category {
  final IconData icon;
  final String title;
  final Color color;
  final Widget screen;

  const Category({
    required this.icon,
    required this.title,
    required this.color,
    required this.screen,
  });
}
