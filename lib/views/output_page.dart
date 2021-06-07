import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dss_application/services/database.dart';
import 'package:flutter/material.dart';

class OutputPage extends StatefulWidget {
  @override
  _OutputPageState createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  Stream<QuerySnapshot> streamData;

  doThisFirst() async {
    streamData = await DatabaseService().queryDataFromDatabase();
  }

  @override
  void initState() {
    super.initState();
    doThisFirst();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: streamData,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Text(ds['username']);
                      })
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
