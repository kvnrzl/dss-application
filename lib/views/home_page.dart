import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dss_application/SAW.dart';
import 'package:dss_application/kriteria.dart';
import 'package:dss_application/services/auth.dart';
import 'package:dss_application/services/database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  Stream<QuerySnapshot> resultData;
  int sawResult;
  bool isProcessed = false;
  List<Map<String, dynamic>> listOfData = [];
  List _weights;
  int _result;
  String _textResult;

  int bobotK1, bobotK2, bobotK3, bobotK4, bobotK5, bobotK6;
  String key1, key2, key3, key4, key5, key6;

  @override
  void initState() {
    super.initState();
  }

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
          child: isProcessed ? resultWidget() : formWidget(),
        ),
      ),
    );
  }

  void onClickAdd() async {
    List dataBobot = [bobotK1, bobotK2, bobotK3, bobotK4, bobotK5, bobotK6];
    double skor = bobotK1 * 0.2 +
        bobotK2 * 0.2 +
        bobotK3 * 0.2 +
        bobotK4 * 0.15 +
        bobotK5 * 0.15 +
        bobotK6 * 0.1;

    // menambahkan data ke database
    Map<String, dynamic> data = {
      "username": usernameController.text,
      "data": dataBobot,
      "skor": skor,
    };
    if (usernameController.text != '') {
      await DatabaseService()
          .addDataIntoDatabase(usernameController.text, data)
          .then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Successfully Added')));
        usernameController.clear();
      }).catchError((onError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(onError)));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Ada data yang belum terisi")));
    }
  }

  void onClickProcess() async {
    resultData = await DatabaseService().queryDataFromDatabase();
    usernameController.clear();
    setState(() {
      isProcessed = true;
    });
  }

  void calculateSAW(var data) {
    listOfData.clear();
    for (int i = 0; i < data.length; i++) {
      listOfData.add({
        "username": data[i]["username"],
        "data": data[i]["data"],
        "skor": data[i]["skor"]
      });
    }
    if (listOfData.isEmpty) {
      listOfData.add({
        "dummy": "dummy",
      });
      _textResult = "Belum ada data";
      return;
    }
    _weights = calculate(listOfData);
    _result = decision(_weights);
    _textResult =
        "${listOfData[_result]["username"]} layak mendapatkan beasiswa";
  }

  void onClickReset() async {
    isProcessed = false;
    await DatabaseService().removeAllDataFromDatabase().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Semua Data Berhasil Dihapus")));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
    setState(() {});
  }

  void onClickBack() async {
    setState(() {
      isProcessed = false;
    });
  }

  void onClickRemove(String doc) async {
    await DatabaseService().removeData(doc).then((_) {
      onClickProcess();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Data $doc berhasil dihapus")));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
  }

  Widget resultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: resultData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                calculateSAW(snapshot.data.docs);
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          // var max = snapshot.data.docs[0]["skor"];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(ds["username"] +
                                  "=" +
                                  (_weights[index]).toStringAsFixed(2)),
                              ElevatedButton.icon(
                                onPressed: () {
                                  onClickRemove(ds["username"]);
                                },
                                icon: Icon(Icons.remove),
                                label: Text("Remove"),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                ),
                              )
                            ],
                          );
                        }),
                    Text("$_textResult"),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  onClickBack();
                },
                icon: Icon(Icons.arrow_back_sharp),
                label: Text("Back")),
            ElevatedButton.icon(
              onPressed: () {
                onClickReset();
              },
              icon: Icon(Icons.restore_from_trash),
              label: Text("Reset Data"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
            ),
          ],
        )
      ],
    );
  }

  Widget formWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await AuthService().signOut();
            setState(() {});
          },
          icon: Icon(Icons.settings_backup_restore_sharp),
          label: Text("Test Sign Out"),
        ),
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
        Row(children: [
          Text('Ranking Kelas'),
          Expanded(
            child: DropdownButton(
                isExpanded: true,
                value: key1,
                onChanged: (newValue) {
                  setState(() {
                    key1 = newValue;
                    bobotK1 = rangking[newValue];
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
        // childFormWidget(
        //     title: 'Ranking Kelas',
        //     keyItems: key1,
        //     bobot: bobotK1,
        //     mapItems: rangking),
        // childFormWidget(
        //     title: 'Pekerjaan Orang Tua',
        //     keyItems: key2,
        //     bobot: bobotK2,
        //     mapItems: pekerjaanOrtu),
        // childFormWidget(
        //     title: 'Penghasilan Orang Tua',
        //     keyItems: key3,
        //     bobot: bobotK3,
        //     mapItems: penghasilanOrtu),
        // childFormWidget(
        //     title: 'Tanggungan Keluarga',
        //     keyItems: key4,
        //     bobot: bobotK4,
        //     mapItems: tanggunganKeluarga),
        // childFormWidget(
        //     title: 'Kondisi Rumah',
        //     keyItems: key5,
        //     bobot: bobotK5,
        //     mapItems: kondisiRumah),
        // childFormWidget(
        //     title: 'Pernah Menerima BOS',
        //     keyItems: key6,
        //     bobot: bobotK6,
        //     mapItems: statusBOS),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                onClickAdd();
              },
              icon: Icon(Icons.add),
              label: Text('Add'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                onClickProcess();
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
      @required String keyItems,
      @required int bobot,
      @required Map mapItems}) {
    return Row(children: [
      Text(title),
      Expanded(
        child: DropdownButton(
            isExpanded: true,
            value: keyItems,
            onChanged: (newValue) {
              setState(() {
                keyItems = newValue;
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
