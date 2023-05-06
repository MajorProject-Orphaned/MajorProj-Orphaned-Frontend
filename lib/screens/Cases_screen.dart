import 'package:flutter/material.dart';
import 'package:orphaned/models/case.dart';
import 'package:orphaned/widgets/app_drawer.dart';
import '../utils/data_processor.dart';
import '../widgets/Cases_Widget.dart';
import '../widgets/app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cases extends StatefulWidget {
  static const routeName = '/Cases';

  @override
  State<Cases> createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map;
    bool is_open = args["is_open"] as bool;
    //print(args);
    return Scaffold(
        body: is_open
            ? CasesWidget(isButtonPressed: true)
            : CasesWidget(isButtonPressed: false));
  }
}
