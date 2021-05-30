import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dss_application/SAW.dart';
import 'package:dss_application/kriteria.dart';
import 'package:dss_application/services/database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  List inputan = [];
  Stream<QuerySnapshot> resultData;
  int sawResult;
  bool isProcessed = false;
  var lists;
  String _result;

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

    print("Data bobot");
    print(dataBobot);

    // menambahkan data ke database
    Map<String, dynamic> data = {
      "username": usernameController.text,
      "data": dataBobot,
      "skor": skor,
    };
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
  }

  void onClickProcess() async {
    isProcessed = true;
    resultData = await DatabaseService().queryDataFromDatabase();
    print(resultData.runtimeType);
    usernameController.clear();
    setState(() {});
  }

  void calculateSAW(var data) async {
    List<Map<String,dynamic>> listOfData = [];
    for(int i=0;i<data.length;i++){
      listOfData.add({
        "username" : data[i]["username"],
        "data" : data[i]["data"],
        "skor" : data[i]["skor"]});
    }
    _result = calculate(listOfData);
  }

  Widget resultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$_result layak mendapatkan beasiswa"),
            ],
        ),
        StreamBuilder<QuerySnapshot>(
            stream: resultData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                calculateSAW(snapshot.data.docs);
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return Center(
                        child:
                            Text(ds["username"] + "=" + ds["skor"].toString()),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
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
