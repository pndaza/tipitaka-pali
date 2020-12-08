import 'package:flutter/material.dart';
import 'book.dart';
import 'package:theme_provider/theme_provider.dart';

import 'category.dart';

abstract class ListItem {
  Widget build(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class CategoryItem implements ListItem {
  final Category category;

  CategoryItem(this.category);

  Widget build(BuildContext context) {
    return Center(
        child: Text(category.name,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ThemeProvider.themeOf(context).data.accentColor)));
  }
}

/// A ListItem that contains data to display a message.
class BookItem implements ListItem {
  final Book book;

  BookItem(this.book);

  Widget build(BuildContext context) => Text(
        book.name,
        style: TextStyle(fontSize: 20),
      );
}
