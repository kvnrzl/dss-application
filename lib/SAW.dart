import 'dart:math';


//C1 Ranking kelas 20% max
//C2 Penghasilan Orang Tua 20% min
//C3 Jumlah Tanggungan Keluarga 20% max
//C4 Status Tempat Tinggal 15% min
//C5 Kondisi Rumah 15% min
//C6 Sumber Air 10% min

var n = 6;
var parameter = [];
var inputan = [];


void generateInput(List<dynamic> list){
  var rng = new Random();
  for(int i=0;i<n;i++){
    list.add(rng.nextInt(100));
  }
}

void main(){
  print("Hello World");
  generateInput(inputan);
  print(inputan);
}