import 'dart:math';

//C1 Ranking kelas 20% max
//C2 Pekerjaan Orang Tua 20% min
//C3 Penghasilan Orang Tua 20% max
//C4 Tanggungan Keluarga 15% min
//C5 Kondisi Rumah 15% min
//C6 Pernah Menerima BOS 10% min

const kriteria = 6;
var bobot = [0.2, 0.2, 0.2, 0.15, 0.15, 0.1];

int findIndMax(List list) {
  double maxValue = 0;
  for (int i = 0; i < list.length; i++) {
    maxValue = max(maxValue, list[i]);
  }
  var index = list.indexOf(maxValue);
  return index;
}

List<List<dynamic>> normalization(List<dynamic> list, int jumlahOrang) {
  //Array 2d Dart
  int row = jumlahOrang;
  int col = kriteria;
  var r = List.generate(row, (i) => List(col), growable: false);

  int maxValue;

  for (int j = 0; j < kriteria; j++) {
    maxValue = 0;
    for (int i = 0; i < jumlahOrang; i++) {
      maxValue = max(maxValue, list[i][j]);
    }
    for (int i = 0; i < jumlahOrang; i++) {
      r[i][j] = list[i][j] / maxValue;
    }
  }
  print(r.runtimeType);
  return r;
}

List<dynamic> weighting(List<List<dynamic>> r) {
  var v = [];
  var sum;
  for (int i = 0; i < r.length; i++) {
    sum = 0;
    for (int j = 0; j < kriteria; j++) {
      sum += r[i][j] * bobot[j];
    }
    v.add(sum);
  }
  return v;
}

int decision(List<dynamic> v) {
  var index;
  index = findIndMax(v);
  // for (int i = 0; i < v.length - 1; i++) {
  //   if (v[i] > v[i + 1]) {
  //     index = i;
  //   } else {
  //     index = i + 1;
  //   }
  //   print("INDEX ${index}");
  // }

  return index;
}

String calculate(List<Map<String, dynamic>> listOfData) {
  var list = [];
  var jumlahOrang = listOfData.length;

  for (int i = 0; i < jumlahOrang; i++) {
    list.add(listOfData[i]["data"]);
  }

  var r = normalization(list, jumlahOrang);
  print("Hasil Normalisasi =");
  for (int i = 0; i < jumlahOrang; i++) {
    print(r[i]);
  }
  var v = weighting(r);
  print("Hasil Pembobotan =\t$v");
  var res = decision(v);

  print("${listOfData[res]["username"]} layak mendapatkan beasiswa");
  return listOfData[res]["username"];
}

void main() {
  print("Hello World");
}
