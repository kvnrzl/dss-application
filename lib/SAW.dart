import 'dart:math';


//C1 Ranking kelas 20% max
//C2 Pekerjaan Orang Tua 20% min
//C3 Penghasilan Orang Tua 20% max
//C4 Tanggungan Keluarga 15% min
//C5 Kondisi Rumah 15% min
//C6 Pernah Menerima BOS 10% min

const n = 8;
var jumlahOrang = 3;
var inputan = [];
var bobot = [0.2,0.2,0.2,0.15,0.15,0.1];

var rangking = {
  'Rangking 1' : 100,
  'Rangking 2' : 75,
  'Rangking 3' : 50,
  'Rangking 4' : 25,
  'Rangking >4' : 0
};


var pekerjaan_ortu = {
  'Tidak Bekerja' : 100,
  'Ibu Rumah Tangga' : 100,
  'Petani/Nelayan' : 75,
  'Swasta' : 50,
  'PNS' : 25
};

var penghasilan_ortu = {
  '<500000' : 100,
  '500000 - 1000000' : 80,
  '1000000 - 2000000' : 60,
  '2000000 - 5000000' : 40,
  '>5000000' : 20
};

var tanggungan_keluarga = {
  '>7 orang' : 100,
  '6-7 orang' : 80,
  '3-5 orang' : 60,
  '2-3 orang' : 40,
  '1 orang' : 20
};

var kondisi_rumah = {
  'Rumah' : {
    'Tepas' : 100,
    'Kayu' : 75,
    'Semi Permanen' : 50,
    'Permanen' : 25,
    'Permanen Bertingkat' : 0
  },
  'Luas' : {
    '<20 meter' : 100,
    '20-36 meter' : 75,
    '37-70 meter' : 50,
    '71-100 meter' : 25,
    '>100 meter' : 0
  },
  'Lantai' : {
    'Tanah' : 100,
    'Kayu' : 75,
    'Semen' : 50,
    'Keramik' : 25,
    'Granit' : 0
  }
};

var status_BOS = {
  'Pernah' : 100,
  'Tidak Pernah' : 50
};


void generateInput(List<dynamic> list){
  var value = [100,75,60,80,25,75,25,50];
  list.add(value);
  value = [75,100,80,80,50,75,50,50];
  list.add(value);
  value = [50,100,100,60,75,75,75,50];
  list.add(value);
}

int find_max(int a, int b){
  if(a>b){
    return a;
  }
  else{
    return b;
  }
}

List<List<dynamic>> normalization(List<dynamic> list,int jumlahOrang){
  //Array 2d Dart
  int row = jumlahOrang;
  int col = n;
  var r = List.generate(row, (i) => List(col), growable: false);

  var max_value;

  for(int j=0;j<n;j++){
    max_value = 0;
    for(int i=0;i<jumlahOrang;i++){
      max_value = find_max(max_value,list[i][j]);
    }
    for(int i=0;i<jumlahOrang;i++){
      r[i][j] = list[i][j] / max_value;
    }
  }
  return r;
}

List<dynamic> weighting(List<List<dynamic>> r){
  var v = [];
  var sum;
  for(int i=0;i<jumlahOrang;i++){
    sum = 0;
    for(int j=0;j<n;j++){
      sum += r[i][j] * bobot[i];
    }
    v.add(sum);
  }
  return v;
}

int decision(List<dynamic> v){
  var index;
  for(int i=0;i<v.length-1;i++){
    if(v[i]>v[i+1]){
      index = i;
    }
    else{
      index = i+1;
    }
  }
  print("Orang ke ${index + 1} layak mendapatkan beasiswa");
  return index;
}

void main(){
  print("Hello World");
  generateInput(inputan);
  for(int i=0;i<jumlahOrang;i++){
    print(inputan[i]);
  }
  var r = normalization(inputan, jumlahOrang);
  var v = weighting(r);
  print("Hasil Normalisasi =");
  for(int i=0;i<jumlahOrang;i++){
    print(r[i]);
  }
  print("Hasil Pembobotan =\t$v");
  decision(v);
}