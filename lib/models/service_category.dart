import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String image;
  final Widget screen;

  const CategoryModel({
    required this.name,
    required this.image,
    required this.screen,
  });
}

const List<CategoryModel> categoryList = [];
