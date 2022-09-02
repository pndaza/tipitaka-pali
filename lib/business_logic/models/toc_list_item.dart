import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'toc.dart';
import '../../services/provider/script_language_provider.dart';
import '../../utils/pali_script.dart';

abstract class TocListItem {
  late Toc toc;
  int getPageNumber();
  Widget build(BuildContext context);
}

class TocHeadingOne implements TocListItem {
  TocHeadingOne(this.toc);

  @override
  final Toc toc;
  @override
  set toc(Toc toc) => this.toc = toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    final tocName = PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: toc.name);
    return Text(tocName,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}

class TocHeadingTwo implements TocListItem {
  TocHeadingTwo(this.toc);
  @override
  final Toc toc;
  @override
  set toc(Toc toc) => this.toc = toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    final tocName = PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: toc.name);
    return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(tocName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
  }
}

class TocHeadingThree implements TocListItem {
  TocHeadingThree(this.toc);
  @override
  final Toc toc;
  @override
  set toc(Toc toc) => this.toc = toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    final tocName = PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: toc.name);
    return Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: Text(tocName, style: const TextStyle(fontSize: 18)));
  }
}

class TocHeadingFour implements TocListItem {
  TocHeadingFour(this.toc);
  @override
  final Toc toc;
  @override
  set toc(Toc toc) => this.toc = toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    final tocName = PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: toc.name);
    return Padding(
        padding: const EdgeInsets.only(left: 48.0),
        child: Text(tocName, style: const TextStyle(fontSize: 18)));
  }
}

class TocHeadingFive implements TocListItem {
  TocHeadingFive(this.toc);
  @override
  final Toc toc;
  @override
  set toc(Toc toc) => this.toc = toc;

  @override
  int getPageNumber() {
    return toc.pageNumber;
  }

  @override
  Widget build(BuildContext context) {
    final tocName = PaliScript.getScriptOf(
        script: context.read<ScriptLanguageProvider>().currentScript,
        romanText: toc.name);
    return Padding(
        padding: const EdgeInsets.only(left: 64.0),
        child: Text(tocName, style: const TextStyle(fontSize: 18)));
  }
}
