import 'package:flutter/material.dart';
import 'package:orphaned/models/case.dart';
import '../utils/Database_manager.dart';
import '../widgets/Cases_Widget.dart';

class Cases extends StatefulWidget {
  static const routeName = '/Cases';

  @override
  State<Cases> createState() => _CasesState();
}

class _CasesState extends State<Cases> {
  bool is_open = true;
  List OpenedCases = [
    Case(
      id: 'abcdef',
      childName: 'Deepak',
      childParentName: 'keepak',
      childParentContact: '8858585858585',
      childAddress: 'fwruef',
      childAge: 22,
      childImage: 'https://picsum.photos/250?image=9',
    ),
    Case(
      id: 'abcdef',
      childName: 'Deepak',
      childParentName: 'keepak',
      childParentContact: '8858585858585',
      childAddress: 'fwruef',
      childAge: 42,
      childImage: 'https://picsum.photos/250?image=9',
    ),
    Case(
      id: 'abcdef',
      childName: 'Deepak',
      childParentName: 'keepak',
      childParentContact: '8858585858585',
      childAddress: 'fwruef',
      childAge: 23,
      childImage: 'https://picsum.photos/250?image=9',
    ),
  ];
  List ClosedCases = [];
  @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // fetchData() async {
  //   dynamic result = await DatabaseManager().getCasesList();

  //   if (result == null) {
  //     print('Unable to retrieve data');
  //   } else {
  //     setState(() {
  //       for (int i = 0; i < result.length; i++) {
  //         if (result[i].isClosed) {
  //           OpenedCases.add(result[i]);
  //         } else {
  //           ClosedCases.add(result[i]);
  //         }
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: is_open ? Text('Opened Cases') : Text('Closed Cases'),
          backgroundColor: Colors.blueGrey,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text('Opened Cases'),
                onTap: () {
                  setState(() {
                    is_open = true;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Closed Cases'),
                onTap: () {
                  setState(() {
                    is_open = false;
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
        body: is_open ? CasesWidget(OpenedCases) : CasesWidget(ClosedCases));
  }
}
