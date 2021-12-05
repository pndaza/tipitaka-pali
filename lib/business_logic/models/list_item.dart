import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/provider/script_language_provider.dart';
import '../../utils/pali_script.dart';
import 'book.dart';
import 'category.dart';

abstract class ListItem {
  Widget build(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class CategoryItem implements ListItem {
  final Category category;

  CategoryItem(this.category);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            PaliScript.getScriptOf(
                script:
                    context.read<ScriptLanguageProvider>().currentScript,
                romanText: category.name),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor)));
  }
}

/// A ListItem that contains data to display a message.
class BookItem implements ListItem {
  final Book book;

  BookItem(this.book);

  @override
  Widget build(BuildContext context) => Text(
        PaliScript.getScriptOf(
                script:
                    context.read<ScriptLanguageProvider>().currentScript,
                romanText: book.name),
        style: const TextStyle(fontSize: 20),
      );
}
