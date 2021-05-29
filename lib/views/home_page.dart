import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dss_application/kriteria.dart';
import 'package:dss_application/saw_method.dart';
import 'package:dss_application/services/database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  List inputan = [];
  List dataBobot;
  Stream<QuerySnapshot> resultData;
  int sawResult;

  int bobotK1, bobotK2, bobotK3, bobotK4, bobotK5, bobotK6;
  String key1, key2, key3, key4, key5, key6;

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Colors.blue,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: formWidget(),
        ),
      ),
    );
  }

  Widget formWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
              hintText: 'Masukkan Username Calon Penerima Beasiswa'),
          validator: (value) {
            if (value.isEmpty)
              return 'Masukkan Username Calon Penerima Beasiswa';
            return null;
          },
        ),
        childFormWidget(
            title: 'Ranking Kelas',
            key: key1,
            bobot: bobotK1,
            mapItems: rangking),
        childFormWidget(
            title: 'Pekerjaan Orang Tua',
            key: key2,
            bobot: bobotK2,
            mapItems: pekerjaanOrtu),
        childFormWidget(
            title: 'Penghasilan Orang Tua',
            key: key3,
            bobot: bobotK3,
            mapItems: penghasilanOrtu),
        childFormWidget(
            title: 'Tanggungan Keluarga',
            key: key4,
            bobot: bobotK4,
            mapItems: tanggunganKeluarga),
        childFormWidget(
            title: 'Kondisi Rumah',
            key: key5,
            bobot: bobotK5,
            mapItems: kondisiRumah),
        childFormWidget(
            title: 'Pernah Menerima BOS',
            key: key6,
            bobot: bobotK6,
            mapItems: statusBOS),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                dataBobot = [
                  bobotK1,
                  bobotK2,
                  bobotK3,
                  bobotK4,
                  bobotK5,
                  bobotK6
                ];
                inputan.add(dataBobot);
                // print('inputan ditambahkan');
                // print(dataBobot);
                print(inputan);

                // menambahkan ke database
                Map<String, dynamic> data = {
                  "username": usernameController.text,
                  "data": dataBobot,
                };
                await DatabaseService()
                    .addDataIntoDatabase(usernameController.text, data)
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully Added')));
                  usernameController.clear();
                }).catchError((onError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(onError)));
                });
              },
              icon: Icon(Icons.add),
              label: Text('Add'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                // resultData =
                //     await DatabaseService().queryDataFromDatabase();
                // var jumlahOrang = resultData.docs.length;
                SAWMethod sawMethod = SAWMethod(inputan.length, inputan);
                sawResult = sawMethod.saw();
                // print('ini data length');
                // print(jumlahOrang);
                // print('ini inputan :');
                print(inputan);
                inputan.clear();
                usernameController.clear();
                setState(() {});
              },
              icon: Icon(Icons.forward),
              label: Text('Process'),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget childFormWidget(
      {@required String title,
      @required String key,
      @required int bobot,
      @required Map mapItems}) {
    return Row(children: [
      Text(title),
      Expanded(
        child: DropdownButton(
            isExpanded: true,
            value: key,
            onChanged: (newValue) {
              setState(() {
                key = newValue;
                bobot = mapItems[newValue];
              });
            },
            items: mapItems.entries.map((entry) {
              return DropdownMenuItem(
                child: Center(child: Text(entry.key)),
                value: entry.key,
              );
            }).toList()),
      )
    ]);
  }
}
