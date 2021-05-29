import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String kriteria1 = 'Rangking 1-2';
  String kriteria2 = 'Tidak Bekerja/IRT';
  String kriteria3 = '<500.000';
  String kriteria4 = '>7 orang';
  String kriteria5 = 'Tepas';
  String kriteria6 = 'Pernah';

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
              Row(children: [
                Text('Rangking Kelas'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria1,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria1 = newValue;
                      });
                    },
                    items: <String>[
                      'Rangking 1-2',
                      'Rangking 3-4',
                      'Rangking 4-5',
                      'Rangking 5-6',
                      'Rangking >6'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              Row(children: [
                Text('Pekerjaan Orang Tua'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria2,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria2 = newValue;
                      });
                    },
                    items: <String>[
                      'Tidak Bekerja/IRT',
                      'Petani/Nelayan',
                      'Swasta',
                      'PNS',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              Row(children: [
                Text('Penghasilan Orang Tua'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria3,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria3 = newValue;
                      });
                    },
                    items: <String>[
                      '<500.000',
                      '500.000 - 1.000.000',
                      '1.000.000 - 2.000.000',
                      '2.000.000 - 5.000.000',
                      '>5.000.000'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              Row(children: [
                Text('Tanggungan Keluarga'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria4,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria4 = newValue;
                      });
                    },
                    items: <String>[
                      '>7 orang',
                      '6 - 7 orang',
                      '3 - 5 orang',
                      '2 - 3 orang',
                      '1 orang'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              Row(children: [
                Text('Kondisi Rumah'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria5,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria5 = newValue;
                      });
                    },
                    items: <String>[
                      'Tepas',
                      'Kayu',
                      'Semi Permanen',
                      'Permanen',
                      'Permanen Bertingkat'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              Row(children: [
                Text('Pernah Menerima BOS'),
                Expanded(
                  child: DropdownButton(
                    isExpanded: true,
                    value: kriteria6,
                    onChanged: (newValue) {
                      setState(() {
                        kriteria6 = newValue;
                      });
                    },
                    items: <String>[
                      'Pernah',
                      'Tidak Pernah',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        child: Center(child: Text(value)),
                        value: value,
                      );
                    }).toList(),
                  ),
                )
              ]),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.send_to_mobile),
                label: Text('Process'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
