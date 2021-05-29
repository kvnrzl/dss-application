import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dss_application/kriteria.dart';
import 'package:dss_application/saw_method.dart';
import 'package:dss_application/services/database.dart';
import 'package:dss_application/views/output_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24)),
                    hintText: 'Masukkan Username Calon Penerima Beasiswa'),
                validator: (value) {
                  if (value.isEmpty)
                    return 'Masukkan Username Calon Penerima Beasiswa';
                  return null;
                },
              ),
              Row(children: [
                Text('Rangking Kelas'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key1,
                      onChanged: (newValue) {
                        setState(() {
                          key1 = newValue;
                          bobotK1 = rangking[newValue];
                          print("bobotK1 = " + bobotK1.toString());
                        });
                      },
                      items: rangking.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
              Row(children: [
                Text('Pekerjaan Orang Tua'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key2,
                      onChanged: (newValue) {
                        setState(() {
                          key2 = newValue;
                          bobotK2 = pekerjaanOrtu[newValue];
                          print("bobotK2 = " + bobotK2.toString());
                        });
                      },
                      items: pekerjaanOrtu.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
              Row(children: [
                Text('Penghasilan Orang Tua'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key3,
                      onChanged: (newValue) {
                        setState(() {
                          key3 = newValue;
                          bobotK3 = penghasilanOrtu[newValue];
                          print("bobotK3 = " + bobotK3.toString());
                        });
                      },
                      items: penghasilanOrtu.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
              Row(children: [
                Text('Tanggungan Keluarga'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key4,
                      onChanged: (newValue) {
                        setState(() {
                          key4 = newValue;
                          bobotK4 = tanggunganKeluarga[newValue];
                          print("bobotK4 = " + bobotK4.toString());
                        });
                      },
                      items: tanggunganKeluarga.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
              Row(children: [
                Text('Kondisi Rumah'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key5,
                      onChanged: (newValue) {
                        setState(() {
                          key5 = newValue;
                          bobotK5 = kondisiRumah[newValue];
                          print("bobotK5 = " + bobotK5.toString());
                        });
                      },
                      items: kondisiRumah.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
              Row(children: [
                Text('Pernah Menerima BOS'),
                Expanded(
                  child: DropdownButton(
                      isExpanded: true,
                      value: key6,
                      onChanged: (newValue) {
                        setState(() {
                          key6 = newValue;
                          bobotK6 = statusBOS[newValue];
                          print("bobotK6 = " + bobotK6.toString());
                        });
                      },
                      items: statusBOS.entries.map((entry) {
                        return DropdownMenuItem(
                          child: Center(child: Text(entry.key)),
                          value: entry.key,
                        );
                      }).toList()),
                )
              ]),
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
              sawResult == null
                  ? Text('')
                  : Text(
                      "Orang ke ${sawResult + 1} layak mendapatkan beasiswa"),
            ],
          ),
        ),
      ),
    );
  }
}
