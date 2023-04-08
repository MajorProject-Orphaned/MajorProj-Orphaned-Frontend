import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Case {
  final String id;
  final String childName;
  final String childParentName;
  final String childParentContact;
  final String childAddress;
  final double childAge;
  final String childImage;

  Case(
      {@required this.id,
      @required this.childName,
      @required this.childParentName,
      @required this.childParentContact,
      @required this.childAddress,
      @required this.childAge,
      @required this.childImage});
}
